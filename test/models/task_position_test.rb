require "test_helper"

class TaskPositionTest < ActiveSupport::TestCase
  def setup
    # Create a fresh child for testing to avoid conflicts with existing data
    @child = Child.create!(name: "Test Child")
  end

  test "tasks sort by position within time period" do
    # Create tasks with different positions
    task1 = @child.tasks.create!(name: "Task 1", time_of_day: "morning", position: 30)
    task2 = @child.tasks.create!(name: "Task 2", time_of_day: "morning", position: 10)
    task3 = @child.tasks.create!(name: "Task 3", time_of_day: "morning", position: 20)

    morning_tasks = @child.tasks.morning.ordered.pluck(:name)

    assert_equal [ "Task 2", "Task 3", "Task 1" ], morning_tasks
  end

  test "position 0 tasks sort before positioned tasks alphabetically" do
    # Create tasks with positions
    task_b = @child.tasks.create!(name: "B Task", time_of_day: "morning", position: 10)
    task_c = @child.tasks.create!(name: "C Task", time_of_day: "morning", position: 0)
    task_a = @child.tasks.create!(name: "A Task", time_of_day: "morning", position: 0)

    morning_tasks = @child.tasks.morning.ordered.pluck(:name)

    # Position 0 comes first (numerically), alphabetically sorted
    assert_equal [ "A Task", "C Task", "B Task" ], morning_tasks
  end

  test "ordering persists across different query methods" do
    task1 = @child.tasks.create!(name: "First", time_of_day: "afternoon", position: 20)
    task2 = @child.tasks.create!(name: "Second", time_of_day: "afternoon", position: 10)

    # Test through association
    ordered_names = @child.active_tasks.afternoon.pluck(:name)
    assert_equal [ "Second", "First" ], ordered_names

    # Test through direct query
    direct_query = Task.where(child: @child, time_of_day: "afternoon").ordered.pluck(:name)
    assert_equal ordered_names, direct_query
  end

  test "name acts as tiebreaker for same position" do
    task_z = @child.tasks.create!(name: "Z Task", time_of_day: "evening", position: 10)
    task_a = @child.tasks.create!(name: "A Task", time_of_day: "evening", position: 10)
    task_m = @child.tasks.create!(name: "M Task", time_of_day: "evening", position: 10)

    evening_tasks = @child.tasks.evening.ordered.pluck(:name)

    # They should be in alphabetical order
    assert_equal [ "A Task", "M Task", "Z Task" ], evening_tasks
  end

  test "different time periods maintain separate ordering" do
    # Morning task with high position
    morning_task = @child.tasks.create!(name: "Morning Last", time_of_day: "morning", position: 100)

    # Afternoon task with low position
    afternoon_task = @child.tasks.create!(name: "Afternoon First", time_of_day: "afternoon", position: 1)

    all_ordered = @child.tasks.ordered.pluck(:name, :time_of_day)

    morning_index = all_ordered.index([ "Morning Last", "morning" ])
    afternoon_index = all_ordered.index([ "Afternoon First", "afternoon" ])

    # Morning tasks always come before afternoon regardless of position
    assert morning_index < afternoon_index
  end
end
