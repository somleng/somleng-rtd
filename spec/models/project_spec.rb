require 'rails_helper'

describe Project do
  let(:factory) { :project }

  describe "validations" do
    context "factory" do
      subject { build(factory) }
      it { is_expected.to be_valid }
    end

    it { is_expected.to validate_presence_of(:phone_calls_count) }

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

    it { is_expected.to validate_presence_of(:phone_call_average_cost_per_minute) }
    it {
      is_expected.to validate_numericality_of(
        :phone_call_average_cost_per_minute
      ).is_greater_than_or_equal_to(0)
    }

    it { is_expected.to validate_presence_of(:sms_average_cost_per_message) }
    it {
      is_expected.to validate_numericality_of(
        :sms_average_cost_per_message
      ).is_greater_than_or_equal_to(0)
    }

    it { is_expected.to validate_presence_of(:twilreapi_account_sid) }
    it { is_expected.to validate_presence_of(:twilreapi_auth_token) }

    it { is_expected.to validate_presence_of(:amount_saved) }
    it { is_expected.to validate_numericality_of(:amount_saved) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:country_code) }
    it { is_expected.to validate_inclusion_of(:country_code).in_array(ISO3166::Country.codes) }

    it { is_expected.to validate_presence_of(:homepage) }
    it { is_expected.not_to allow_value("http://localhost:8000").for(:homepage) }
    it { is_expected.to allow_value("http://my-project.com").for(:homepage) }

    it { is_expected.to validate_presence_of(:twilreapi_host) }
    it { is_expected.not_to allow_value("http://localhost:8000").for(:twilreapi_host) }
    it { is_expected.to allow_value("http://my-project.com/api").for(:twilreapi_host) }
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

  describe "timestamps" do
    let(:timestamp) { Time.new(2014, 03, 01, 0, 0, 0, "+00:00") }
    let(:asserted_rfc2822_time) { "Sat, 01 Mar 2014 00:00:00 +0000" }

    subject { create(factory, :created_at => timestamp, :updated_at => timestamp) }

    def assert_rfc2822!(result)
      expect(result).to eq(asserted_rfc2822_time)
    end

    describe "#date_created" do
      it { assert_rfc2822!(subject.date_created) }
    end

    describe "#date_updated" do
      it { assert_rfc2822!(subject.date_updated) }
    end
  end

  describe "#to_json" do
    subject { create(factory) }
    let(:json) { JSON.parse(subject.to_json) }
    let(:asserted_json_keys) {
      [
        "id", "country_code", "description", "name", "homepage",
        "phone_calls_count", "sms_count", "date_created", "date_updated",
        "phone_call_average_cost_per_minute", "sms_average_cost_per_message",
        "twilio_phone_call_cost_per_minute", "twilio_sms_cost_per_message",
        "twilio_phone_call_pricing_url", "twilio_sms_pricing_url",
        "amount_saved", "currency"
      ]
    }

    def assert_json!
      expect(json.keys).to match_array(asserted_json_keys)
    end

    it { assert_json! }
  end

  describe "twilio price comparisons" do
    let(:country_code) { "US" }
    subject { create(factory, :country_code => country_code) }

    include EnvHelpers

    before do
      stub_env(
        "twilio_phone_call_cost_per_minute_#{country_code}" => "0.015",
        "twilio_sms_cost_per_message_#{country_code}" =>  "0.0075"
      )
    end

    describe "#twilio_phone_call_cost_per_minute" do
      it { expect(subject.twilio_phone_call_cost_per_minute).to eq(0.015) }
    end

    describe "#twilio_sms_cost_per_message" do
      it { expect(subject.twilio_sms_cost_per_message).to eq(0.0075) }
    end

    describe "#twilio_phone_call_pricing_url" do
      it { expect(subject.twilio_phone_call_pricing_url).to eq("https://www.twilio.com/voice/pricing/us") }
    end

    describe "#twilio_sms_pricing_url" do
      it { expect(subject.twilio_sms_pricing_url).to eq("https://www.twilio.com/sms/pricing/us") }
    end
  end
end
