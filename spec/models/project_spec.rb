require 'rails_helper'

describe Project do
  let(:factory) { :project }

  describe "validations" do
    context "factory" do
      subject { build(factory) }

      it { is_expected.to be_valid }
    end

    it { is_expected.to validate_presence_of(:phone_calls_count) }

    it {
      is_expected.to validate_numericality_of(
        :phone_calls_count
      ).only_integer.is_greater_than_or_equal_to(0)
    }

    it { is_expected.to validate_presence_of(:sms_count) }

    it {
      is_expected.to validate_numericality_of(
        :sms_count
      ).only_integer.is_greater_than_or_equal_to(0)
    }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:homepage) }
    it { is_expected.to validate_presence_of(:twilreapi_host) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:country_code) }
    it { is_expected.to validate_inclusion_of(:country_code).in_array(ISO3166::Country.codes) }


    it { is_expected.to validate_presence_of(:phone_call_average_unit_cost_per_minute) }
    it {
      is_expected.to validate_numericality_of(
        :phone_call_average_unit_cost_per_minute
      ).is_greater_than_or_equal_to(0)
    }

    it { is_expected.to validate_presence_of(:sms_average_unit_cost_per_message) }
    it {
      is_expected.to validate_numericality_of(
        :sms_average_unit_cost_per_message
      ).is_greater_than_or_equal_to(0)
    }
  end

  describe "encryption" do
    subject { build(factory) }

    def assert_encrypted!(attribute_name)
      encrypted_attribute_name = "encrypted_#{attribute_name}"
      expect(subject.public_send(encrypted_attribute_name)).not_to eq(subject.public_send(attribute_name))
      expect(subject.encryption_data).to have_key("#{encrypted_attribute_name}_iv")
    end

    it { assert_encrypted!(:twilreapi_account_sid) }
    it { assert_encrypted!(:twilreapi_auth_token) }
  end
end
