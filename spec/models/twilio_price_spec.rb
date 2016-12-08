require 'rails_helper'

describe TwilioPrice do
  let(:factory) { :twilio_price }
  let(:asserted_currency) { described_class::DEFAULT_CURRENCY }

  include_examples "twilio_timestamps"

  describe "associations" do
    it { is_expected.to have_many(:projects) }
  end

  describe "validations" do
    context "factory" do
      subject { build(factory) }
      it { is_expected.to be_valid }
    end

    it { is_expected.to validate_numericality_of(:average_outbound_voice_price).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:average_outbound_sms_price).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_presence_of(:country_code) }
    it { is_expected.to validate_inclusion_of(:country_code).in_array(ISO3166::Country.codes) }
  end

  describe "#average_outbound_voice_price" do
    it { is_expected.to monetize(:average_outbound_voice_price) }
  end

  describe "#average_outbound_sms_price" do
    it { is_expected.to monetize(:average_outbound_sms_price) }
  end

  describe "#to_json" do
    subject { create(factory) }
    let(:json) { JSON.parse(subject.to_json) }
    let(:asserted_json_keys) {
      [
        "country_code", "outbound_voice_price", "outbound_sms_price",
        "voice_url", "sms_url",
        "date_created", "date_updated",
      ]
    }

    def assert_json!
      expect(json.keys).to match_array(asserted_json_keys)
    end

    it { assert_json! }
  end

  describe "price display methods" do
    let(:average_outbound_voice_price) { Money.new(100000, asserted_currency) }
    let(:average_outbound_sms_price) { Money.new(50000, asserted_currency) }

    subject {
      build(
        factory,
        :average_outbound_voice_price => average_outbound_voice_price,
        :average_outbound_sms_price => average_outbound_sms_price
      )
    }

    describe "#outbound_voice_price" do
      it { expect(subject.outbound_voice_price).to eq("$0.100000") }
    end

    describe "#outbound_sms_price" do
      it { expect(subject.outbound_sms_price).to eq("$0.050000") }
    end
  end

  describe "pricing url methods" do
    subject { build(factory, :country_code => "KH") }

    describe "#voice_url" do
      it { expect(subject.voice_url).to eq("https://www.twilio.com/voice/pricing/kh") }
    end

    describe "#sms_url" do
      it { expect(subject.sms_url).to eq("https://www.twilio.com/sms/pricing/kh") }
    end
  end

  describe "fetching price updates", :vcr, :cassette => :fetch_twilio_prices do
    include EnvHelpers

    let(:country_code) { "KH" }
    let(:asserted_average_outbound_voice_price) { Money.new(100000, asserted_currency) }
    let(:asserted_average_outbound_sms_price) { Money.new(44000, asserted_currency) }

    def env_vars
      {
        :twilio_account_sid => "twilio_account_sid",
        :twilio_auth_token => "auth_token"
      }
    end

    def setup_scenario
      stub_env(env_vars)
    end

    def assert_price_updated!(twilio_price)
      expect(twilio_price).to be_persisted
      expect(twilio_price.average_outbound_voice_price).to eq(asserted_average_outbound_voice_price)
      expect(twilio_price.average_outbound_sms_price).to eq(asserted_average_outbound_sms_price)
    end

    before do
      setup_scenario
    end

    describe ".fetch_new(*countries)" do
      let(:new_twilio_price) { described_class.find_by_country_code(country_code) }
      let(:countries) { [] }

      def do_fetch_new!
        described_class.fetch_new!(*countries)
      end

      def setup_scenario
        super
        do_fetch_new!
      end

      context "countries are specified via ENV" do
        def env_vars
          super.merge(:twilio_price_countries => country_code)
        end

        it { expect(new_twilio_price).to be_persisted }
      end

      context "countries are specified via args" do
        let(:countries) { ["kh"] }
        it { expect(new_twilio_price).to be_persisted }
      end

      context "no countries are specified" do
        it { expect(new_twilio_price).to eq(nil) }
      end
    end

    describe ".fetch!" do
      let(:existing_twilio_price) { create(factory, :country_code => country_code) }

      def setup_scenario
        super
        existing_twilio_price
        described_class.fetch!
      end

      it { assert_price_updated!(existing_twilio_price.reload) }
    end

    describe "#fetch!" do
      subject { build(factory, :country_code => country_code) }

      def setup_scenario
        super
        subject.fetch!
      end

      it { assert_price_updated!(subject) }
    end
  end
end
