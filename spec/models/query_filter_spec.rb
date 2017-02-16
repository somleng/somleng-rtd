require 'rails_helper'

describe QueryFilter do
  let(:factory) { :query_filter }

  describe "#initialize" do
    let(:attributes) { attributes_for(factory) }

    let(:params) {
      {
        "StartDate" => attributes[:start_date],
        "EndDate" => attributes[:end_date]
      }
    }

    subject { described_class.new(params) }

    def assert_initialized!
      expect(subject.start_date).to eq(attributes[:start_date])
      expect(subject.end_date).to eq(attributes[:end_date])
    end

    it { assert_initialized! }
  end

  describe "validations" do
    it { is_expected.to allow_value("2016-09-30").for(:start_date) }
    it { is_expected.not_to allow_value("2016-09-31").for(:start_date) }
    it { is_expected.not_to allow_value("foobarbz").for(:start_date) }
    it { is_expected.to allow_value("2016-09-30").for(:end_date) }
    it { is_expected.not_to allow_value("2016-09-31").for(:end_date) }
    it { is_expected.not_to allow_value("foobarbz").for(:end_date) }

    describe "end_date" do
      let(:start_date) { Date.new(2015, 9, 30) }
      subject { build(factory, :start_date => start_date) }

      it { is_expected.to allow_value("2016-09-30").for(:end_date) }
      it { is_expected.not_to allow_value("2015-09-29").for(:end_date) }
    end
  end
end
