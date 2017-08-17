require 'rails_helper'

describe RealTimeData do
  describe "#to_json" do
    let(:json) { JSON.parse(subject.to_json) }
    let(:asserted_json_keys) {
      [
        "date_updated",
        "calls_count", "calls_outbound_count", "calls_inbound_count",
        "calls_minutes", "calls_outbound_minutes", "calls_inbound_minutes",
        "sms_count", "sms_outbound_count", "sms_inbound_count",
        "total_amount_spent", "total_equivalent_twilio_price",
        "total_amount_saved",  "projects_count", "countries_count", "continents_count"
      ]
    }

    def assert_json!
      expect(json.keys).to match_array(asserted_json_keys)
    end

    it { assert_json! }
  end

  describe "#countries_count, #continents_count" do
    let(:cambodia) { create(:twilio_price, :country_code => "KH") }

    def setup_scenario
      cambodia
      create(:twilio_price, :country_code => "SO")
      create(:twilio_price, :country_code => "TH")
    end

    before do
      setup_scenario
    end

    def assert_result!
      expect(subject.countries_count).to eq(asserted_countries_count)
      expect(subject.continents_count).to eq(asserted_continents_count)
    end

    context "given no project scope" do
      let(:asserted_countries_count) { 3 }
      let(:asserted_continents_count) { 2 }

      it { assert_result! }
    end

    context "given a project scope" do
      let(:asserted_countries_count) { 1 }
      let(:asserted_continents_count) { 1 }

      def setup_scenario
        super
        subject.project = create(:project, :twilio_price => cambodia)
      end

      it { assert_result! }
    end
  end

  describe "#date_updated" do
    let(:result) { subject.date_updated }

    context "given there are no projects" do
      it { expect(result).to eq(nil) }
    end

    context "given there are projects" do
      let(:first_updated_at) { Time.new(2014, 03, 01, 0, 0, 0, "+00:00") }
      let(:last_updated_at) { Time.new(2014, 03, 01, 0, 0, 1, "+00:00") }
      let(:asserted_last_updated_at) { "Sat, 01 Mar 2014 00:00:01 +0000" }

      before do
        create(:project, :updated_at => first_updated_at)
        create(:project, :updated_at => last_updated_at)
      end

      it { expect(result).to eq(asserted_last_updated_at) }
    end
  end

  describe "aggregations" do
    let(:project_aggregations) {
      create_list(
        :project_aggregation,
        2,
        :calls_count => 3,
        :sms_count => 5
      )
    }

    def setup_scenario
    end

    before do
      setup_scenario
    end

    context "given there are no projects" do
      def assert_no_data!
        expect(subject.calls_count).to eq(0)
        expect(subject.sms_count).to eq(0)
        expect(subject.projects_count).to eq(0)
        expect(subject.total_amount_saved).to eq("$0.00")
      end

      it { assert_no_data! }
    end

    context "given there are projects" do
      def setup_scenario
        project_aggregations
      end

      def assert_data!
        expect(subject.calls_count).to eq(6)
        expect(subject.sms_count).to eq(10)
        expect(subject.projects_count).to eq(2)
        expect(subject.total_amount_saved).to eq("$0.00")
      end

      it { assert_data! }
    end
  end
end
