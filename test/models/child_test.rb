require "test_helper"

class ChildTest < ActiveSupport::TestCase
  def test_valid_child_with_name
    child = Child.new(name: "Test Child")
    assert child.valid?
  end

  def test_requires_name
    child = Child.new(name: "")
    assert_not child.valid?
    assert_includes child.errors[:name], "can't be blank"
  end

  def test_name_must_be_unique
    existing_child = children(:eddie)
    child = Child.new(name: existing_child.name)
    assert_not child.valid?
    assert_includes child.errors[:name], "has already been taken"
  end

  def test_has_default_theme
    child = Child.create!(name: "New Child")
    assert_equal "default", child.theme
  end

  def test_only_returns_active_tasks
    eddie = children(:eddie)
    active_tasks_count = eddie.active_tasks.count
    total_tasks_count = eddie.tasks.count

    assert_equal 3, active_tasks_count
    assert_equal 4, total_tasks_count
  end

  def test_has_task_completions_through_tasks
    eddie = children(:eddie)
    completions = eddie.task_completions

    assert_equal 3, completions.count
    assert completions.all? { |tc| tc.task.child_id == eddie.id }
  end

  def test_destroying_child_destroys_tasks
    eddie = children(:eddie)
    task_ids = eddie.tasks.pluck(:id)

    eddie.destroy

    assert task_ids.all? { |id| Task.find_by(id: id).nil? }
  end

  def test_active_tasks_are_ordered
    eddie = children(:eddie)
    active_tasks = eddie.active_tasks

    task_names = active_tasks.map(&:name)
    assert_equal [ "Make bed", "Clean room", "Take out trash" ], task_names
  end
end
