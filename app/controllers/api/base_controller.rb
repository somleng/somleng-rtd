class Api::BaseController < ApplicationController
  self.responder = Api::QueryFilterResponder

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

  def query_filter
    @query_filter ||= build_query_filter
  end

  private

  def build_query_filter
    query_filter = QueryFilter.new(query_filter_params)
    query_filter.valid?
    query_filter
  end

  def query_filter_params
    params.permit("StartDate", "EndDate")
  end

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

  def project_scope
    Project.published
  end
end
