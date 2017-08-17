require 'rails_helper'

describe ProjectAggregation do
  let(:factory) { :project_aggregation }

  include_examples "date_filters" do
    let(:date_column) { :date }
  end

  describe "associations" do
    it { is_expected.to belong_to(:project).touch(true) }
  end

  describe "validations" do
    context "factory" do
      subject { build(factory) }
      it { is_expected.to be_valid }
    end

    it { is_expected.to validate_presence_of(:project) }

    context "persisted" do
      subject { create(factory) }
      it { is_expected.to validate_uniqueness_of(:date).scoped_to([:project_id]).case_insensitive }

      [:calls, :calls_inbound, :calls_outbound, :sms, :sms_inbound, :sms_outbound].each do |aggregation|
        count_column = "#{aggregation}_count"
        it { is_expected.to validate_presence_of(count_column) }

        it {
          is_expected.to validate_numericality_of(
            count_column
          ).only_integer.is_greater_than_or_equal_to(0)
        }

        price_column = "#{aggregation}_price"
        it { is_expected.to validate_numericality_of(price_column) }
        it { is_expected.to monetize(price_column) }
      end

      it { is_expected.to validate_presence_of(:calls_minutes) }
      it {
        is_expected.to validate_numericality_of(
          :calls_minutes
        ).only_integer.is_greater_than_or_equal_to(0)
      }

      it { is_expected.to validate_presence_of(:calls_inbound_minutes) }
      it {
        is_expected.to validate_numericality_of(
          :calls_inbound_minutes
        ).only_integer.is_greater_than_or_equal_to(0)
      }

      it { is_expected.to validate_presence_of(:calls_outbound_minutes) }
      it {
        is_expected.to validate_numericality_of(
          :calls_outbound_minutes
        ).only_integer.is_greater_than_or_equal_to(0)
      }
    end
  end

  describe ".by_date(date)" do
    let(:result) { described_class.by_date(date_argument) }
    let(:project_aggregation) { create(factory, :date => date) }
    let(:date) { Date.new(2016, 9, 30) }

    before do
      project_aggregation
    end

    context "passing a date with an existing project aggregation" do
      let(:date_argument) { date }
      it { expect(result).to match_array([project_aggregation]) }
    end

    context "passing a date without an existing project aggregation" do
      let(:date_argument) { Date.new(2016, 9, 29) }
      it { expect(result).to match_array([]) }
    end
  end

  describe "price aggregations" do
    before do
      setup_scenario
    end

    def setup_scenario
      project_aggregation
    end

    let(:twilio_price) {
      create(
        :twilio_price,
        :average_inbound_voice_price_microunits => 7000,
        :average_outbound_voice_price_microunits => 100000,
        :average_inbound_sms_price_microunits => 7500,
        :average_outbound_sms_price_microunits => 50000,
      )
    }

    let(:project) { create(:project, :twilio_price => twilio_price) }
    let(:project_aggregation) {
      create(
        factory,
        :calls_inbound_minutes => 1000000,
        :calls_inbound_price_cents => 50,
        :calls_outbound_minutes => 200,
        :calls_outbound_price_cents => 100,
        :sms_inbound_count => 25,
        :sms_inbound_price_cents => 12,
        :sms_outbound_count => 50,
        :sms_outbound_price_cents => 25,
        :project => project
      )
    }

    let(:asserted_currency) { described_class::DEFAULT_CURRENCY }

    describe ".total_amount_spent" do
      # 50 + 100 + 12 + 25 = 187
      it { expect(described_class.total_amount_spent).to eq(Money.new(187, asserted_currency)) }
    end

    describe ".total_equivalent_twilio_price" do
      # (1000000 * 7000) + (200 * 100000) + (25 * 7500) + (50 * 50000) = 7022687500
      it { expect(described_class.total_equivalent_twilio_price).to eq(Money.new(702269, asserted_currency)) }
    end

    describe ".total_amount_saved" do
      # 702269 - 187 = 702082
      it { expect(described_class.total_amount_saved).to eq(Money.new(702082, asserted_currency)) }
    end
  end

  describe "#fetch!", :vcr, :cassette => :fetch_usage_records, :vcr_options => {:match_requests_on => [:method, :twilreapi_api_resource]} do
    subject { build(factory, :date => date) }

    let(:date) { Date.new(2017, 2, 15) }
    let(:asserted_date) { "2017-02-15" }

    let(:external_request) { WebMock.requests.last }
    let(:query_params) { WebMock::Util::QueryMapper.query_to_values(external_request.uri.query) }

    def setup_scenario
      subject.fetch!
    end

    before do
      setup_scenario
    end

    def assert_fetch!
      subject.reload

      expect(external_request).to be_present
      expect(query_params["StartDate"]).to eq(asserted_date)
      expect(query_params["EndDate"]).to eq(asserted_date)

      # from cassette
      expect(subject.calls_count).to eq(677)
      expect(subject.calls_minutes).to eq(1114)
      expect(subject.calls_price_cents).to eq(0)
      expect(subject.calls_inbound_count).to eq(534)
      expect(subject.calls_inbound_minutes).to eq(971)
      expect(subject.calls_inbound_price_cents).to eq(0)
      expect(subject.calls_outbound_count).to eq(143)
      expect(subject.calls_outbound_minutes).to eq(143)
      expect(subject.calls_outbound_price_cents).to eq(0)
      expect(subject.sms_count).to eq(0)
      expect(subject.sms_price_cents).to eq(0)
      expect(subject.sms_inbound_count).to eq(0)
      expect(subject.sms_inbound_price_cents).to eq(0)
      expect(subject.sms_outbound_count).to eq(0)
      expect(subject.sms_outbound_price_cents).to eq(0)
    end

    it { assert_fetch! }
  end
end
