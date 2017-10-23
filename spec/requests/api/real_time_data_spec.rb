require 'rails_helper'

describe "real_time_data" do
  let(:query_params) { {} }
  let(:projects_count) { JSON.parse(response.body)["projects_count"] }
  let(:skip_before_do_request) { false }

  def setup_scenario
  end

  before do
    setup_scenario
    do_request if !skip_before_do_request
  end

  describe 'GET /api/real_time_data.json' do
    let(:projects) { create_list(:project, 2) }
    let(:unpublished_project) { create(:project, :status => "unpublished") }

    def setup_scenario
      super
      projects
      unpublished_project
    end

    def do_request
      get(api_real_time_data_path(query_params))
    end

    context "valid request" do
      def assert_success!
        expect(response.code).to eq("200")
      end

      context "without filtering" do
        def assert_success!
          super
          expect(projects_count).to eq(2)
        end

        it { assert_success! }
      end

      context "filtering" do
        let(:start_date) { Date.new(2016, 9, 30) }
        let(:end_date) { Date.new(2016, 9, 30) }
        let(:query_params) { {"StartDate" => start_date, "EndDate" => end_date} }
        let(:project) { create(:project, :created_at => start_date) }

        def setup_scenario
          project
          super
        end

        def assert_success!
          super
          expect(projects_count).to eq(1)
        end

        it { assert_success! }
      end
    end

    context "invalid request" do
      let(:query_params) { { "StartDate" => "foobarbaz", "EndDate" => "2015-01-22" } }

      def assert_invalid_request!
        expect(response.code).to eq("422")
      end

      it { assert_invalid_request! }
    end
  end

  describe "'GET /api/projects/:project_id/real_time_data.json'" do
    let(:project) { create(:project, project_attributes) }
    let(:unrelated_project) { create(:project) }

    def project_attributes
      {}
    end

    def setup_scenario
      unrelated_project
      super
    end

    def do_request
      get(api_project_real_time_data_path(project, query_params))
    end

    context "published" do
      def assert_success!
        expect(response.code).to eq("200")
        expect(JSON.parse(response.body)["projects_count"]).to eq(1)
      end

      it { assert_success! }
    end

    context "unpublished" do
      let(:skip_before_do_request) { true }

      def project_attributes
        super.merge(:status => :unpublished)
      end

      def assert_not_found!
        expect { do_request }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it { assert_not_found! }
    end
  end
end
