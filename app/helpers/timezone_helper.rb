module TimezoneHelper
  # Format a date for display, considering it represents a calendar date
  # The actual timezone conversion happens client-side
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

  # Check if a given date represents "today" from the server's perspective
  # Client-side JavaScript will handle the actual local timezone comparison
  def is_today?(date)
    date == Date.current
  end

  # Get the date string in YYYY-MM-DD format
  def date_param_string(date)
    date.strftime("%Y-%m-%d")
  end

  # Generate data attributes for timezone-aware elements
  def timezone_data_attributes(date_or_time)
    return {} if date_or_time.nil?

    {
      "data-utc-date" => date_or_time.respond_to?(:iso8601) ? date_or_time.iso8601 : date_or_time.to_s,
      "data-timezone-target" => "date"
    }
  end

  # Generate data attributes for time display
  def timezone_time_attributes(time)
    return {} if time.nil?

    {
      "data-utc-date" => time.iso8601,
      "data-timezone-target" => "time",
      "data-format" => "time"
    }
  end

  # Generate data attributes for full datetime display
  def timezone_datetime_attributes(datetime)
    return {} if datetime.nil?

    {
      "data-utc-date" => datetime.iso8601,
      "data-timezone-target" => "datetime",
      "data-format" => "datetime"
    }
  end

  # Helper to add timezone controller to a page/section
  def with_timezone_support(options = {})
    defaults = {
      "data-controller" => "timezone",
      "data-timezone-cache-key-value" => "chore_tracker_timezone",
      "data-timezone-fallback-warning-value" => "false"
    }

    defaults.merge(options)
  end

  # Get the start of the current week (for weekly reviews)
  # Returns the date as-is since actual timezone handling is client-side
  def week_start_date(date = Date.current, start_day = :sunday)
    # Ruby's beginning_of_week uses Monday by default
    if start_day == :sunday
      date.beginning_of_week(:sunday)
    else
      date.beginning_of_week
    end
  end

  # Get the end of the current week
  def week_end_date(date = Date.current, start_day = :sunday)
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

  # Helper to check if browser timezone should be used
  def use_browser_timezone?
    # Always true for this implementation since we're doing client-side conversion
    true
  end
end
