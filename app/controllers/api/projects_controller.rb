class Api::ProjectsController < Api::BaseController

  private

  def association_chain
    Project
  end
end
