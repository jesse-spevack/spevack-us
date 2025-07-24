class WeeklySummaryResult
  attr_reader :total_expected, :total_completed, :task_details

  def initialize(total_expected:, total_completed:, task_details:)
    @total_expected = total_expected
    @total_completed = total_completed
    @task_details = task_details
  end

  def overall_percentage
    return 100 if total_expected == 0
    (total_completed * 100.0 / total_expected).round
  end

  def perfect_tasks
    task_details.select(&:perfect?)
  end

  def incomplete_tasks
    task_details.reject(&:perfect?)
                .sort_by { |task| -task.percentage }
  end
end