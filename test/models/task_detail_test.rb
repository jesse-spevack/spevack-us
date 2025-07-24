require "test_helper"

class TaskDetailTest < ActiveSupport::TestCase
  def setup
    @task = tasks(:make_bed)
  end

  def test_percentage_calculation
    detail = TaskDetail.new(task: @task, expected: 10, completed: 8, missing_dates: [])
    assert_equal 80, detail.percentage
  end

  def test_percentage_with_zero_expected
    detail = TaskDetail.new(task: @task, expected: 0, completed: 0, missing_dates: [])
    assert_equal 100, detail.percentage
  end

  def test_perfect_returns_true_for_100_percent
    detail = TaskDetail.new(task: @task, expected: 5, completed: 5, missing_dates: [])
    assert detail.perfect?
  end

  def test_perfect_returns_false_for_less_than_100_percent
    detail = TaskDetail.new(task: @task, expected: 5, completed: 4, missing_dates: [])
    assert_not detail.perfect?
  end

  def test_attributes_are_accessible
    missing_dates = [ Date.current, Date.current + 1.day ]
    detail = TaskDetail.new(
      task: @task,
      expected: 7,
      completed: 5,
      missing_dates: missing_dates
    )

    assert_equal @task, detail.task
    assert_equal 7, detail.expected
    assert_equal 5, detail.completed
    assert_equal missing_dates, detail.missing_dates
  end
end
