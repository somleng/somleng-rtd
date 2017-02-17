shared_examples_for "date_filters" do
  describe ".between_dates(start_date, end_date)" do
    let(:created_at) { Time.utc("2015", "9", "30", "23", "33", "46") }
    subject { create(factory, :created_at => created_at) }

    before do
      subject
    end

    def assert_between_dates!
      expect(
        described_class.between_dates(
          Date.new(2015, 9, 29), Date.new(2015, 9, 29)
        )
      ).to match_array([])

      expect(
        described_class.between_dates(
          Date.new(2015, 9, 30), Date.new(2015, 9, 30)
        )
      ).to match_array([subject])

      expect(
        described_class.between_dates(
          "2015-09-30", "2015-09-30"
        )
      ).to match_array([subject])

      expect(
        described_class.between_dates(
          Date.new(2015, 9, 30), nil
        )
      ).to match_array([subject])

      expect(
        described_class.between_dates(
          nil, Date.new(2015, 9, 30)
        )
      ).to match_array([subject])

      expect(
        described_class.between_dates(
          nil, nil
        )
      ).to match_array([subject])
    end

    it { assert_between_dates! }
  end
end
