class ReviewsController < ApplicationController
  before_action :require_child

  def show
    @child = current_child
    @week_start = (params[:week_start]&.to_date || Date.current).beginning_of_week
    @week_end = @week_start.end_of_week

    @summary = calculate_weekly_summary
  end

  private

  def calculate_weekly_summary
    total_expected = 0
    total_completed = 0
    task_details = []

    @child.active_tasks.each do |task|
      expected_dates = dates_for_task_in_week(task)
      completed_dates = task.task_completions
                            .where(completed_on: @week_start..@week_end)
                            .pluck(:completed_on)

      expected_count = expected_dates.count
      completed_count = completed_dates.count

      total_expected += expected_count
      total_completed += completed_count

      task_details << {
        task: task,
        expected: expected_count,
        completed: completed_count,
        percentage: expected_count > 0 ? (completed_count * 100.0 / expected_count).round : 100,
        missing_dates: expected_dates - completed_dates
      }
    end

    {
      total_expected: total_expected,
      total_completed: total_completed,
      overall_percentage: total_expected > 0 ? (total_completed * 100.0 / total_expected).round : 100,
      perfect_tasks: task_details.select { |t| t[:percentage] == 100 },
      incomplete_tasks: task_details.select { |t| t[:percentage] < 100 }.sort_by { |t| -t[:percentage] }
    }
  end

  def dates_for_task_in_week(task)
    (@week_start..@week_end).select { |date| task.due_on?(date) }
  end
end
