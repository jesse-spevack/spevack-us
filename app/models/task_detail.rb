class TaskDetail
  attr_reader :task, :expected, :completed, :missing_dates

  def initialize(task:, expected:, completed:, missing_dates:)
    @task = task
    @expected = expected
    @completed = completed
    @missing_dates = missing_dates
  end

  def percentage
    return 100 if expected == 0
    (completed * 100.0 / expected).round
  end

  def perfect?
    percentage == 100
  end
end