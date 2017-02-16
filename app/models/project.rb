class Project < ApplicationRecord
  include ApiResource
  include TwilioTimestamps
  extend DateFilter::Scopes

  HOSTNAME_REGEXP = /\A(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])\z/

  belongs_to :twilio_price
  has_many   :project_aggregations

  validates :name, :description, :twilio_price, :presence => true

  validates :homepage, :presence => true, :url => {:no_local => true}
  validates :twilreapi_host, :presence => true, :format => HOSTNAME_REGEXP
  validates :twilreapi_account_sid, :twilreapi_auth_token, :presence => true
  validates :status, :presence => true

  store :encryption_data,
        :accessors => [
          :encrypted_twilreapi_account_sid_iv,
          :encrypted_twilreapi_auth_token_iv
        ]

  attr_encrypted :twilreapi_account_sid,
                 :key => Rails.application.secrets[:twilreapi_account_sid_encryption_key]

  attr_encrypted :twilreapi_auth_token,
                 :key => Rails.application.secrets[:twilreapi_auth_token_encryption_key]

  delegate :country_name, :to => :twilio_price
  delegate :voice_url, :sms_url, :to => :twilio_price, :prefix => true

  include AASM

  aasm :column => :status do
    state :published, :initial => true
  end

  def self.fetch!
    all.find_each { |project| project.fetch! }
  end

  def fetch!
    project_aggregations.by_date(Date.today).first_or_initialize.fetch!
  end

  private

  def json_attributes
    super.merge(
      :id => nil,
      :name => nil,
      :description => nil,
      :homepage => nil
    )
  end

  def json_methods
    super.merge(
      :date_created => nil,
      :twilio_price => nil
    )
  end
end
