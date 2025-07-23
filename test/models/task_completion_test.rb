require "test_helper"

class TaskCompletionTest < ActiveSupport::TestCase
  def test_valid_completion_with_task_and_date
    completion = TaskCompletion.new(
      task: tasks(:clean_room),
      completed_on: Date.current
    )
    assert completion.valid?
  end

  def test_requires_completed_on_date
    completion = TaskCompletion.new(task: tasks(:clean_room))
    assert_not completion.valid?
    assert_includes completion.errors[:completed_on], "can't be blank"
  end

  def test_requires_task
    completion = TaskCompletion.new(completed_on: Date.current)
    assert_not completion.valid?
    assert_includes completion.errors[:task], "must exist"
  end

  def test_prevents_duplicate_completions_for_same_task_and_date
    existing = task_completions(:bed_completed_today)
    duplicate = TaskCompletion.new(
      task: existing.task,
      completed_on: existing.completed_on
    )
    
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:task_id], "has already been taken"
  end

  def test_allows_same_task_on_different_dates
    task = tasks(:clean_room)
    yesterday = TaskCompletion.create!(
      task: task,
      completed_on: Date.current - 1.day
    )
    today = TaskCompletion.new(
      task: task,
      completed_on: Date.current
    )
    
    assert today.valid?
  end

  def test_allows_different_tasks_on_same_date
    completion1 = task_completions(:bed_completed_today)
    completion2 = TaskCompletion.new(
      task: tasks(:clean_room),
      completed_on: completion1.completed_on
    )
    
    assert completion2.valid?
  end

  def test_belongs_to_task
    completion = task_completions(:bed_completed_today)
    assert_equal tasks(:make_bed), completion.task
  end
end