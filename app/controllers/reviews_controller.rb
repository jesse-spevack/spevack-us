class ReviewsController < ApplicationController
  include TimezoneHelper

  before_action :require_child

  def show
    @child = current_child
    # Parse the week start date in user's timezone
    base_date = params[:week_start].present? ? Time.zone.parse(params[:week_start]).to_date : Time.zone.today.beginning_of_week - 7.days
    @week_start = week_start_date(base_date, :monday)
    @week_end = week_end_date(base_date, :monday)

    # DEBUG: Log what we're actually calculating
    Rails.logger.error "=== WEEKLY REVIEW DEBUG ==="
    Rails.logger.error "params[:week_start]: #{params[:week_start].inspect}"
    Rails.logger.error "base_date: #{base_date}"
    Rails.logger.error "@week_start: #{@week_start}"
    Rails.logger.error "@week_end: #{@week_end}"
    Rails.logger.error "Time.zone.today: #{Time.zone.today}"
    Rails.logger.error "=========================="

    @summary = WeeklySummary.get(@child, @week_start)
  end
end
