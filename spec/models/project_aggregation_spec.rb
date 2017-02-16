require 'rails_helper'

describe ProjectAggregation do
  let(:factory) { :project_aggregation }

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
      it { is_expected.to validate_uniqueness_of(:project_id).scoped_to([:year, :month, :day]).case_insensitive }
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

    it { is_expected.to validate_numericality_of(:amount_saved) }

    it { is_expected.to validate_presence_of(:year) }
    it { is_expected.to validate_presence_of(:month) }
    it { is_expected.to validate_presence_of(:day) }
  end

  describe "money" do
    it { is_expected.to monetize(:amount_saved) }
  end

  describe ".by_date(date)" do
    let(:result) { described_class.by_date(date) }
    let(:project_aggregation) { create(factory, :year => year, :month => month, :day => day) }
    let(:year) { 2016 }
    let(:month) { 9 }
    let(:day) { 30 }

    before do
      project_aggregation
    end

    context "passing a date with an existing project aggregation" do
      let(:date) { Date.new(year, month, day) }
      it { expect(result).to match_array([project_aggregation]) }
    end

    context "passing a date without an existing project aggregation" do
      let(:date) { Date.new(year, month, 29) }
      it { expect(result).to match_array([]) }
    end
  end

  describe ".amount_saved" do
    let(:asserted_currency) { described_class::DEFAULT_CURRENCY }

    before do
      create_list(factory, 2, :amount_saved => Money.new(100, asserted_currency))
    end

    it { expect(described_class.amount_saved).to eq(Money.new(200, asserted_currency)) }
  end

  describe "#fetch!", :vcr, :focus, :cassette => :fetch_usage_records, :vcr_options => {:match_requests_on => [:method, :twilreapi_api_resource]} do
    subject { build(factory, :year => year, :month => month, :day => day) }

    let(:year) { 2017 }
    let(:month) { 2 }
    let(:day) { 15 }

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

      # from cassette
      expect(subject.phone_calls_count).to eq(677)
      expect(subject.sms_count).to eq(0)
      expect(subject.amount_saved).to eq(Money.new(1430, "USD"))

      expect(external_request).to be_present
      expect(query_params["StartDate"]).to eq(asserted_date)
      expect(query_params["EndDate"]).to eq(asserted_date)
    end

    it { assert_fetch! }
  end
end
