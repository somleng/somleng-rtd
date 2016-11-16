require 'rails_helper'

describe 'GET /api/real_time_data.json' do

  let(:projects) { create_list(:project, 2) }

  def setup_scenario
    projects
  end

  def do_request
    get(api_real_time_data_path)
  end

  before do
    setup_scenario
    do_request
  end

  def assert_success!
    expect(response.code).to eq("200")
    expect(response.body).to eq(RealTimeData.new.to_json)
  end

  it { assert_success! }
end
