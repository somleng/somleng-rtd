class Api::ProjectsController < Api::BaseController

  private

  def find_resources
    super.includes(:twilio_price)
  end

  def association_chain
    Project
  end
end
