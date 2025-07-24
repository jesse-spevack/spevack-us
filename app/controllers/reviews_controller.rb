class ReviewsController < ApplicationController
  before_action :require_child

  def show
    @child = current_child
    @week_start = (params[:week_start]&.to_date || Date.current).beginning_of_week
    @week_end = @week_start.end_of_week

    @summary = WeeklySummary.get(@child, @week_start)
  end
end
