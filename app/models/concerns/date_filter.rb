module DateFilter
  module Scopes
    def between_dates(start_date, end_date)
      created_on_or_after_date(start_date).merge(created_on_or_before_date(end_date))
    end

    def cast_as_date(column_name)
      Arel::Nodes::NamedFunction.new('CAST', [arel_table[column_name].as('DATE')])
    end

    def created_on_or_after_date(date)
      date ? where(cast_as_date(:created_at).gteq(date)) : all
    end

    def created_on_or_before_date(date)
      date ? where(cast_as_date(:created_at).lteq(date)) : all
    end
  end
end
