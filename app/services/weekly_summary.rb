class WeeklySummary
  def self.get(child, week_start = Date.current.beginning_of_week)
    new(child, week_start).get
  end

  def initialize(child, week_start)
    @child = child
    @week_start = week_start
    @week_end = week_start.end_of_week
  end

  def get
    task_details = calculate_task_details

    WeeklySummaryResult.new(
      total_expected: task_details.sum(&:expected),
      total_completed: task_details.sum(&:completed),
      task_details: task_details
    )
  end

  private

  attr_reader :child, :week_start, :week_end

  def calculate_task_details
    child.active_tasks.map do |task|
      expected_dates = task.dates_for_week(week_start)
      completed_dates = task.task_completions
                           .where(completed_on: week_start..week_end)
                           .pluck(:completed_on)

      expected_count = expected_dates.count
      completed_count = completed_dates.count

      TaskDetail.new(
        task: task,
        expected: expected_count,
        completed: completed_count,
        missing_dates: expected_dates - completed_dates
      )
    end
  end
end
