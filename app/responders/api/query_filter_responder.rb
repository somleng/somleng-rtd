class Api::QueryFilterResponder < ActionController::Responder
  def to_format
    if get? && has_query_filter_errors? && !response_overridden?
      display_filter_errors
    else
      super
    end
  end

  private

  def query_filter
    controller.query_filter
  end

  def has_query_filter_errors?
    query_filter.respond_to?(:errors) && !query_filter.errors.empty?
  end

  def display_filter_errors
    controller.render(format => filter_errors, :status => :unprocessable_entity)
  end

  def filter_errors
    respond_to?("#{format}_filter_errors", true) ? send("#{format}_filter_errors") : query_filter.errors
  end

  def json_filter_errors
    {:errors => query_filter.errors}
  end
end
