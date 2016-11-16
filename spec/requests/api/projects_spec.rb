require 'rails_helper'

describe "Projects" do
  def setup_scenario
  end

  before do
    setup_scenario
    do_request
  end

  describe "GET '/api/projects.json'" do
    let(:projects) { create_list(:project, 2) }

    def setup_scenario
      projects
    end

    def do_request
      get(api_projects_path)
    end

    def assert_success!
      expect(response.code).to eq("200")
      expect(response.body).to eq(projects.to_json)
    end

    it { assert_success! }
  end

  describe "GET '/api/projects/:id.json'" do
    let(:project) { create(:project) }

    def setup_scenario
      project
    end

    def do_request
      get(api_project_path(project))
    end

    def assert_success!
      expect(response.code).to eq("200")
      expect(response.body).to eq(project.to_json)
    end

    it { assert_success! }
  end
end
