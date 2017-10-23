require 'rails_helper'

describe "Home Page" do
  def setup_scenario
    visit(home_path)
  end

  before do
    setup_scenario
  end

  def assert_home_page!
    expect(page).to have_selector("#overview")
    expect(page).to have_selector("#projects")
    expect(page).to have_selector("#api")
  end

  context "no projects" do
    it { assert_home_page! }
  end

  context "has projects" do
    let(:project) { create(:project, project_attributes) }

    def project_attributes
      {}
    end

    def setup_scenario
      project
      super
    end

    context "published" do
      def assert_home_page!
        super
        expect(page).to have_selector("##{project.id}")
      end

      it { assert_home_page! }
    end

    context "unpublished" do
      def project_attributes
        {:status => "unpublished"}
      end

      def assert_home_page!
        super
        expect(page).to have_no_selector("##{project.id}")
      end

      it { assert_home_page! }
    end
  end
end
