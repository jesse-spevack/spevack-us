class ReviewsController < ApplicationController
  include TimezoneHelper

  before_action :require_child

  def show
    @child = current_child
    # Parse the week start date in user's timezone
    base_date = params[:week_start].present? ? Time.zone.parse(params[:week_start]).to_date : Time.zone.today - 7.days
    @week_start = week_start_date(base_date, :monday)
    @week_end = week_end_date(base_date, :monday)

    @summary = WeeklySummary.get(@child, @week_start)
  end
end
