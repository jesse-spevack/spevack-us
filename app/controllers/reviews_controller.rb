class ReviewsController < ApplicationController
  include TimezoneHelper

  before_action :require_child

  def show
    @child = current_child
    # Week boundaries should be based on user's local timezone
    # The date parameter is expected to be in the user's local date
    base_date = params[:week_start].present? ? Date.parse(params[:week_start]) : Date.current
    @week_start = week_start_date(base_date, :sunday)
    @week_end = week_end_date(base_date, :sunday)

    @summary = WeeklySummary.get(@child, @week_start)
  end
end
