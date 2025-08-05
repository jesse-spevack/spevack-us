module TimezoneHelper
  # Format a date for display
  def format_date_for_display(date, format = :long)
    return "" if date.nil?

    case format
    when :long
      date.strftime("%A, %B %d")
    when :short
      date.strftime("%b %d")
    when :full
      date.strftime("%A, %B %d, %Y")
    else
      date.to_s
    end
  end

  # Check if a given date represents "today" in user's timezone
  def today?(date)
    date == Time.zone.today
  end

  # Get the date string in YYYY-MM-DD format
  def date_param_string(date)
    date.strftime("%Y-%m-%d")
  end

  # Get the start of the current week (for weekly reviews)
  def week_start_date(date = Time.zone.today, start_day = :sunday)
    # Ruby's beginning_of_week uses Monday by default
    if start_day == :sunday
      date.beginning_of_week(:sunday)
    else
      date.beginning_of_week
    end
  end

  # Get the end of the current week
  def week_end_date(date = Time.zone.today, start_day = :sunday)
    week_start_date(date, start_day) + 6.days
  end

  # Format a week range for display
  def format_week_range(start_date, end_date = nil)
    end_date ||= start_date + 6.days

    if start_date.month == end_date.month
      "#{start_date.strftime('%B %d')} - #{end_date.strftime('%d, %Y')}"
    else
      "#{start_date.strftime('%B %d')} - #{end_date.strftime('%B %d, %Y')}"
    end
  end
end
