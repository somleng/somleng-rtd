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
    let(:project) { create(:project) }

    def setup_scenario
      project
      super
    end

    it { assert_home_page! }
  end
end
