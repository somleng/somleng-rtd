require 'rails_helper'

describe RealTimeData do
  describe "#to_json" do
    let(:json) { JSON.parse(subject.to_json) }
    let(:asserted_json_keys) {
      [
        "date_updated", "phone_calls_count", "sms_count", "projects_count",
        "amount_saved"
      ]
    }

    def assert_json!
      expect(json.keys).to match_array(asserted_json_keys)
    end

    it { assert_json! }
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
        :phone_calls_count => 3,
        :sms_count => 5,
        :amount_saved => Money.new(100, ProjectAggregation::DEFAULT_CURRENCY)
      )
    }

    def setup_scenario
    end

    before do
      setup_scenario
    end

    context "given there are no projects" do
      def assert_no_data!
        expect(subject.phone_calls_count).to eq(0)
        expect(subject.sms_count).to eq(0)
        expect(subject.projects_count).to eq(0)
        expect(subject.amount_saved).to eq("$0.00")
      end

      it { assert_no_data! }
    end

    context "given there are projects" do
      def setup_scenario
        project_aggregations
      end

      def assert_data!
        expect(subject.phone_calls_count).to eq(6)
        expect(subject.sms_count).to eq(10)
        expect(subject.projects_count).to eq(2)
        expect(subject.amount_saved).to eq("$2.00")
      end

      it { assert_data! }
    end
  end
end
