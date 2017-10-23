class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def projects_scope
    Project.published
  end
end
