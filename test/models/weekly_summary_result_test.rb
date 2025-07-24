require "test_helper"

class WeeklySummaryResultTest < ActiveSupport::TestCase
  def setup
    @task = tasks(:make_bed)
    @perfect_detail = TaskDetail.new(task: @task, expected: 5, completed: 5, missing_dates: [])
    @incomplete_detail = TaskDetail.new(task: @task, expected: 5, completed: 3, missing_dates: [])
    @task_details = [@perfect_detail, @incomplete_detail]
  end

  def test_overall_percentage_calculation
    result = WeeklySummaryResult.new(
      total_expected: 10,
      total_completed: 8,
      task_details: @task_details
    )
    
    assert_equal 80, result.overall_percentage
  end

  def test_overall_percentage_with_zero_expected
    result = WeeklySummaryResult.new(
      total_expected: 0,
      total_completed: 0,
      task_details: []
    )
    
    assert_equal 100, result.overall_percentage
  end

  def test_perfect_tasks_filters_correctly
    result = WeeklySummaryResult.new(
      total_expected: 10,
      total_completed: 8,
      task_details: @task_details
    )
    
    perfect_tasks = result.perfect_tasks
    assert_equal 1, perfect_tasks.count
    assert_equal @perfect_detail, perfect_tasks.first
  end

  def test_incomplete_tasks_filters_and_sorts_correctly
    task2 = tasks(:clean_room)
    high_incomplete = TaskDetail.new(task: task2, expected: 10, completed: 8, missing_dates: [])
    low_incomplete = TaskDetail.new(task: @task, expected: 10, completed: 2, missing_dates: [])
    
    result = WeeklySummaryResult.new(
      total_expected: 25,
      total_completed: 15,
      task_details: [@perfect_detail, low_incomplete, high_incomplete]
    )
    
    incomplete_tasks = result.incomplete_tasks
    assert_equal 2, incomplete_tasks.count
    # Should be sorted by percentage descending (80% then 20%)
    assert_equal high_incomplete, incomplete_tasks.first
    assert_equal low_incomplete, incomplete_tasks.last
  end

  def test_attributes_are_accessible
    result = WeeklySummaryResult.new(
      total_expected: 15,
      total_completed: 12,
      task_details: @task_details
    )
    
    assert_equal 15, result.total_expected
    assert_equal 12, result.total_completed
    assert_equal @task_details, result.task_details
  end
end