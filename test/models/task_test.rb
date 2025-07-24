require "test_helper"

class TaskTest < ActiveSupport::TestCase
  def test_valid_task_with_required_attributes
    task = Task.new(
      child: children(:eddie),
      name: "New Task",
      frequency: "daily"
    )
    assert task.valid?
  end

  def test_requires_name
    task = Task.new(child: children(:eddie), frequency: "daily")
    assert_not task.valid?
    assert_includes task.errors[:name], "can't be blank"
  end

  def test_requires_child
    task = Task.new(name: "Task", frequency: "daily")
    assert_not task.valid?
    assert_includes task.errors[:child], "must exist"
  end

  def test_validates_frequency_values
    task = Task.new(child: children(:eddie), name: "Task", frequency: "invalid")
    assert_not task.valid?
    assert_includes task.errors[:frequency], "is not included in the list"
  end

  def test_time_of_day_enum
    task = tasks(:make_bed)
    assert_equal "morning", task.time_of_day
    assert task.morning?

    task.afternoon!
    assert task.afternoon?
  end

  def test_ordered_scope_sorts_by_time_then_name
    eddie = children(:eddie)
    ordered_tasks = eddie.tasks.ordered

    assert_equal "Make bed", ordered_tasks.first.name
    assert_equal "morning", ordered_tasks.first.time_of_day
  end

  def test_daily_task_due_every_day
    task = tasks(:make_bed)
    monday = Date.new(2025, 1, 6)
    sunday = Date.new(2025, 1, 5)

    assert task.due_on?(monday)
    assert task.due_on?(sunday)
  end

  def test_weekend_task_due_on_weekends_only
    task = tasks(:clean_room)
    monday = Date.new(2025, 1, 6)
    saturday = Date.new(2025, 1, 4)
    sunday = Date.new(2025, 1, 5)

    assert_not task.due_on?(monday)
    assert task.due_on?(saturday)
    assert task.due_on?(sunday)
  end

  def test_specific_days_task_due_on_specified_days
    task = tasks(:take_out_trash)
    monday = Date.new(2025, 1, 6)    # wday = 1
    tuesday = Date.new(2025, 1, 7)   # wday = 2
    wednesday = Date.new(2025, 1, 8) # wday = 3

    assert task.due_on?(monday)
    assert_not task.due_on?(tuesday)
    assert task.due_on?(wednesday)
  end

  def test_specific_days_task_not_due_when_days_blank
    task = Task.new(frequency: "specific_days", specific_days: "")
    date = Date.current

    assert_not task.due_on?(date)
  end

  def test_completed_on_returns_true_when_completion_exists
    task = tasks(:make_bed)
    assert task.completed_on?(Date.current)
  end

  def test_completed_on_returns_false_when_no_completion
    task = tasks(:clean_room)
    assert_not task.completed_on?(Date.current)
  end

  def test_destroying_task_destroys_completions
    task = tasks(:make_bed)
    completion_ids = task.task_completions.pluck(:id)

    task.destroy

    assert completion_ids.all? { |id| TaskCompletion.find_by(id: id).nil? }
  end

  def test_task_completion_for_day_returns_completion_when_exists
    task = tasks(:make_bed)
    completion = task.task_completion_for_day(Date.current)

    assert_not_nil completion
    assert_equal task, completion.task
    assert_equal Date.current, completion.completed_on
  end

  def test_task_completion_for_day_returns_nil_when_not_exists
    task = tasks(:clean_room)
    completion = task.task_completion_for_day(Date.current)

    assert_nil completion
  end

  def test_dates_for_week_returns_dates_task_is_due
    task = tasks(:make_bed) # daily task
    week_start = Date.new(2025, 1, 6) # Monday

    dates = task.dates_for_week(week_start)

    assert_equal 7, dates.count
    assert_equal week_start, dates.first
    assert_equal week_start + 6.days, dates.last # Sunday
  end

  def test_dates_for_week_weekend_task
    task = tasks(:clean_room) # weekend task
    week_start = Date.new(2025, 1, 6) # Monday

    dates = task.dates_for_week(week_start)

    assert_equal 2, dates.count
    assert_includes dates, Date.new(2025, 1, 11) # Saturday
    assert_includes dates, Date.new(2025, 1, 12) # Sunday
  end

  def test_dates_for_week_specific_days_task
    task = tasks(:take_out_trash) # specific_days: "1,3,5" (Mon, Wed, Fri)
    week_start = Date.new(2025, 1, 6) # Monday

    dates = task.dates_for_week(week_start)

    assert_equal 3, dates.count
    assert_includes dates, Date.new(2025, 1, 6)  # Monday
    assert_includes dates, Date.new(2025, 1, 8)  # Wednesday
    assert_includes dates, Date.new(2025, 1, 10) # Friday
  end
end
