require 'rails_helper'

describe Project do
  let(:factory) { :project }

  include_examples "twilio_timestamps"

  include_examples "date_filters" do
    let(:date_column) { :created_at }
  end

  describe "associations" do
    it { is_expected.to belong_to(:twilio_price) }
    it { is_expected.to have_many(:project_aggregations) }
  end

  describe "validations" do
    context "factory" do
      subject { build(factory) }
      it { is_expected.to be_valid }
    end

    it { is_expected.to validate_presence_of(:twilio_price) }
    it { is_expected.to validate_presence_of(:twilreapi_account_sid) }
    it { is_expected.to validate_presence_of(:twilreapi_auth_token) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:homepage) }
    it { is_expected.not_to allow_value("http://localhost:8000").for(:homepage) }
    it { is_expected.to allow_value("http://my-project.com").for(:homepage) }

    it { is_expected.to validate_presence_of(:twilreapi_host) }
    it { is_expected.not_to allow_value("http://localhost:8000").for(:twilreapi_host) }
    it { is_expected.not_to allow_value("http://my-project.com/api").for(:twilreapi_host) }
    it { is_expected.to allow_value("my-project.com").for(:twilreapi_host) }
  end

  describe "state_machine" do
    def subject_attributes
      {:status => current_status}
    end

    subject { create(factory, subject_attributes) }

    context "status is 'published'" do
      let(:current_status) { :published }

      def assert_transitions!
        is_expected.to transition_from(:published).to(:unpublished).on_event(:unpublish)
      end

      it { assert_transitions! }
    end

    context "status is 'unpublished'" do
      let(:current_status) { :unpublished }

      def assert_transitions!
        is_expected.to transition_from(:unpublished).to(:published).on_event(:publish)
      end

      it { assert_transitions! }
    end
  end

  describe "encryption" do
    subject { build(factory) }

    def assert_encrypted!(attribute_name)
      encrypted_attribute_name = "encrypted_#{attribute_name}"
      expect(subject.public_send(encrypted_attribute_name)).not_to eq(subject.public_send(attribute_name))
      expect(subject.encryption_data).to have_key("#{encrypted_attribute_name}_iv")
    end

    it { assert_encrypted!(:twilreapi_account_sid) }
    it { assert_encrypted!(:twilreapi_auth_token) }
  end

  describe ".fetch" do
    let(:unpublished_project) {
      create(:project, :status => "unpublished")
    }

    let(:projects) { [unpublished_project] }

    before do
      setup_scenario
    end

    def setup_scenario
      projects
      described_class.fetch!
    end

    def assert_fetch!
      expect(unpublished_project.project_aggregations).to be_empty
    end

    it { assert_fetch! }
  end

  describe "#to_json" do
    subject { create(factory) }
    let(:json) { JSON.parse(subject.to_json) }
    let(:asserted_json_keys) {
      [
        "id", "description", "name", "homepage",
        "date_created", "date_updated",
        "twilio_price"
      ]
    }

    def assert_json!
      expect(json.keys).to match_array(asserted_json_keys)
    end

    it { assert_json! }
  end
end
