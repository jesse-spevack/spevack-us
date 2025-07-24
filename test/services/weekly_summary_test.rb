require "test_helper"

class WeeklySummaryTest < ActiveSupport::TestCase
  def setup
    @child = children(:eddie)
    @week_start = Date.current.beginning_of_week
  end

  def test_get_returns_weekly_summary_result
    result = WeeklySummary.get(@child, @week_start)
    
    assert_instance_of WeeklySummaryResult, result
    assert_instance_of Integer, result.total_expected
    assert_instance_of Integer, result.total_completed
    assert_instance_of Array, result.task_details
  end

  def test_get_with_no_tasks
    child_with_no_tasks = Child.create!(name: "Empty Child")
    result = WeeklySummary.get(child_with_no_tasks, @week_start)
    
    assert_equal 0, result.total_expected
    assert_equal 0, result.total_completed
    assert_equal 100, result.overall_percentage
    assert_empty result.task_details
  end

  def test_get_calculates_totals_correctly
    # Clear existing tasks to test with just one
    @child.tasks.destroy_all
    
    # Create a simple task for testing
    task = @child.tasks.create!(
      name: "Test task",
      time_of_day: "morning",
      frequency: "daily"
    )
    
    # Complete task for 3 days of the week
    3.times do |i|
      task.task_completions.create!(completed_on: @week_start + i.days)
    end
    
    result = WeeklySummary.get(@child, @week_start)
    
    # Should expect 7 days (daily task)
    assert_equal 7, result.total_expected
    assert_equal 3, result.total_completed
    assert_equal 43, result.overall_percentage # 3/7 * 100 = 42.857... rounded to 43
  end

  def test_get_creates_task_details
    # Clear existing tasks to test with just one
    @child.tasks.destroy_all
    
    task = @child.tasks.create!(
      name: "Test task",
      time_of_day: "morning",
      frequency: "weekend"
    )
    
    result = WeeklySummary.get(@child, @week_start)
    
    assert_equal 1, result.task_details.count
    task_detail = result.task_details.first
    assert_instance_of TaskDetail, task_detail
    assert_equal task, task_detail.task
    assert_equal 2, task_detail.expected # Weekend = Saturday + Sunday
  end
end