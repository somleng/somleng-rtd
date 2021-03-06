require 'rails_helper'

describe "Projects" do
  let(:query_params) { {} }
  let(:skip_before_do_request) { false }

  def setup_scenario
  end

  before do
    setup_scenario
    do_request if !skip_before_do_request
  end

  describe "GET '/api/projects.json'" do
    let(:projects) { create_list(:project, 2) }

    def setup_scenario
      projects
    end

    def do_request
      get(api_projects_path(query_params))
    end

    def assert_success!
      expect(response.code).to eq("200")
    end

    context "valid request" do

      context "without filtering" do
        def assert_success!
          super
          expect(response.body).to eq(projects.to_json)
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
          expect(response.body).to eq([project].to_json)
        end

        it { assert_success! }
      end
    end

    context "invalid request" do
      let(:query_params) { { "StartDate" => "FooBarBaz"}  }

      def assert_invalid_request!
        expect(response.code).to eq("422")
      end

      it { assert_invalid_request! }
    end
  end

  describe "GET '/api/projects/:id.json'" do
    let(:project) { create(:project, project_attributes) }

    def project_attributes
      {}
    end

    def setup_scenario
      project
    end

    def do_request
      get(api_project_path(project))
    end

    context "published project" do
      def assert_success!
        expect(response.code).to eq("200")
        expect(response.body).to eq(project.to_json)
      end

      it { assert_success! }
    end

    context "unpublished project" do
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
