class Api::BaseController < ApplicationController
  protect_from_forgery :with => :null_session

  respond_to :json

  def index
    find_resources
    respond_with_resource(resources)
  end

  def show
    find_resource
    respond_with_resource(resource)
  end

  private

  def find_resources
    @resources = association_chain.all
  end

  def find_resource
    @resource = association_chain.find(params[:id])
  end

  def resource
    @resource
  end

  def resources
    @resources
  end

  def respond_with_resource(resource)
    respond_with(:api, resource)
  end
end
