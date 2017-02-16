class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value || !options[:allow_nil]
      begin
        parsed_date = Date.parse(value.to_s)
        record.errors.add(attribute, :invalid) if options[:on_or_after] && record.public_send(options[:on_or_after]) && parsed_date < record.public_send(options[:on_or_after])
      rescue ArgumentError => e
        record.errors.add(attribute, :invalid)
      end
    end
  end
end
