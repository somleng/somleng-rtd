module ApiResource
  extend ActiveSupport::Concern

  def serializable_hash(options = nil)
    options ||= {}
    super(
      {
        :only    => json_attributes.keys,
        :methods => json_methods.keys
      }.merge(options)
    )
  end

  private

  def json_attributes
    {}
  end

  def json_methods
    {
      :date_updated => nil
    }
  end
end
