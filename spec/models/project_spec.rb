require 'rails_helper'

describe Project do
  let(:factory) { :project }

  include_examples "twilio_timestamps"

  describe "associations" do
    it { is_expected.to belong_to(:twilio_price) }
  end

  describe "validations" do
    context "factory" do
      subject { build(factory) }
      it { is_expected.to be_valid }
    end

    it { is_expected.to validate_presence_of(:phone_calls_count) }
    it { is_expected.to validate_presence_of(:twilio_price) }

    it {
      is_expected.to validate_numericality_of(
        :phone_calls_count
      ).only_integer.is_greater_than_or_equal_to(0)
    }

    it { is_expected.to validate_presence_of(:sms_count) }

    it {
      is_expected.to validate_numericality_of(
        :sms_count
      ).only_integer.is_greater_than_or_equal_to(0)
    }

    it { is_expected.to validate_presence_of(:twilreapi_account_sid) }
    it { is_expected.to validate_presence_of(:twilreapi_auth_token) }

    it { is_expected.to validate_numericality_of(:amount_saved) }

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

  describe "money" do
    it { is_expected.to monetize(:amount_saved) }
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

  describe "#to_json" do
    subject { create(factory) }
    let(:json) { JSON.parse(subject.to_json) }
    let(:asserted_json_keys) {
      [
        "id", "description", "name", "homepage",
        "phone_calls_count", "sms_count", "date_created", "date_updated",
        "twilio_price", "amount_saved"
      ]
    }

    def assert_json!
      expect(json.keys).to match_array(asserted_json_keys)
      expect(json["amount_saved"]).to be_a(String)
    end

    it { assert_json! }
  end

  describe "#fetch!", :vcr, :cassette => :fetch_usage_records, :vcr_options => {:match_requests_on => [:method, :twilreapi_api_resource]} do
    subject { create(factory) }

    def setup_scenario
      subject.fetch!
    end

    before do
      setup_scenario
    end

    def assert_fetch!
      subject.reload
      # from cassette
      expect(subject.phone_calls_count).to eq(1947)
      expect(subject.sms_count).to eq(0)
    end

    it { assert_fetch! }
  end

  describe ".amount_saved" do
    let(:asserted_currency) { described_class::DEFAULT_CURRENCY }

    before do
      create_list(factory, 2, :amount_saved => Money.new(100, asserted_currency))
    end

    it { expect(described_class.amount_saved).to eq(Money.new(200, asserted_currency)) }
  end
end
