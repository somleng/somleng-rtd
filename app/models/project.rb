class Project < ApplicationRecord
  validates :phone_calls_count, :sms_count,
            :presence => true,
            :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }

  validates :name, :description, :homepage, :presence => true
  validates :twilreapi_host, :presence => true
  validates :country_code, :presence => true, :inclusion => {:in => :available_countries}

  validates :phone_call_average_unit_cost_per_minute, :sms_average_unit_cost_per_message,
            :presence => true,
            :numericality => { :greater_than_or_equal_to => 0 }

  validates :status, :presence => true

  delegate :available_countries, :to => :class

  store :encryption_data,
        :accessors => [
          :encrypted_twilreapi_account_sid_iv,
          :encrypted_twilreapi_auth_token_iv
        ]

  attr_encrypted :twilreapi_account_sid,
                 :key => Rails.application.secrets[:twilreapi_account_sid_encryption_key]

  attr_encrypted :twilreapi_auth_token,
                 :key => Rails.application.secrets[:twilreapi_auth_token_encryption_key]

  include AASM

  aasm :column => :status do
    state :published, :initial => true
  end

  def self.available_countries
    ISO3166::Country.codes
  end
end
