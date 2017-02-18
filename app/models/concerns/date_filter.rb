module DateFilter
  module Scopes
    def between_dates(start_date, end_date)
      created_on_or_after_date(start_date).merge(created_on_or_before_date(end_date))
    end

    def cast_as_date(column_name)
      Arel::Nodes::NamedFunction.new('CAST', [arel_table[column_name].as('DATE')])
    end

    def created_on_or_after_date(date)
      date ? where(between_dates_arel_column.gteq(date)) : all
    end

    def created_on_or_before_date(date)
      date ? where(between_dates_arel_column.lteq(date)) : all
    end

    def between_dates_column_name
      :created_at
    end

    def between_dates_arel_column
      between_dates_cast_as_date? ? cast_as_date(between_dates_column_name) : arel_table[between_dates_column_name]
    end

    def between_dates_cast_as_date?
      column_for_attribute(between_dates_column_name).type != :date
    end
  end
end
