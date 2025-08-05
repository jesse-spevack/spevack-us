# Deployment Checklist: Custom Chore Ordering

**Feature**: Task position-based ordering within time periods
**Date**: 2025-08-05

## Pre-Deployment Checklist

- [ ] Ensure all tests pass locally: `bin/rails test`
- [ ] Run linting: `bundle exec rubocop`
- [ ] Verify migration status: `bin/rails db:migrate:status`
- [ ] Review changed files:
  - `db/migrate/20250805023921_add_position_to_tasks.rb`
  - `app/models/task.rb`
  - `lib/tasks/set_task_positions.rake`
  - `test/models/task_position_test.rb`
  - `CLAUDE.md` (documentation update)

## Production Deployment Steps

### 1. Deploy Code Changes
```bash
# Deploy the application with new code
# (Use your normal deployment process - git push, capistrano, etc.)
```

### 2. Run Database Migration
```bash
# On production server
RAILS_ENV=production bin/rails db:migrate

# Verify migration completed
RAILS_ENV=production bin/rails db:migrate:status
```

### 3. Set Initial Task Positions
```bash
# Run the rake task to set positions for all existing tasks
RAILS_ENV=production bin/rails tasks:set_positions

# Expected output:
# - Shows position updates for each child
# - Reports total tasks updated
# - Displays sample ordering
```

### 4. Verify in Rails Console
```bash
RAILS_ENV=production bin/rails console

# Check a sample child's task ordering
child = Child.first
child.tasks.morning.ordered.pluck(:name, :position)

# Verify SQL includes position in ORDER BY
puts Task.ordered.to_sql
# Should show: ORDER BY "tasks"."time_of_day" ASC, "tasks"."position" ASC, "tasks"."name" ASC
```

### 5. Spot Check UI
- Visit the tasks page for a child
- Verify morning tasks appear in logical order (get dressed → make bed → brush teeth)
- Check that afternoon and evening tasks are also properly ordered
- Navigate through different dates to ensure ordering persists

### 6. Monitor for Issues
- Watch application logs for any errors
- Check that task completion still works properly
- Verify weekly review shows tasks in correct order

## Post-Deployment Verification

### Console Commands for Verification
```ruby
# Check all children have positioned tasks
Child.find_each do |child|
  unpositioned = child.tasks.where(position: 0).count
  positioned = child.tasks.where("position > 0").count
  puts "#{child.name}: #{positioned} positioned, #{unpositioned} unpositioned"
end

# View specific child's ordering
child = Child.find_by(name: "Jake")
%w[morning afternoon evening].each do |period|
  puts "\n#{period.capitalize}:"
  child.tasks.where(time_of_day: period).ordered.limit(5).each do |task|
    puts "  #{task.position}: #{task.name}"
  end
end
```

### Manual Position Adjustments (if needed)
```ruby
# If a task needs repositioning
task = Task.find_by(name: "homework", child: child)
task.update!(position: 15)  # Place between 10 and 20

# Reset a child's tasks to alphabetical
child.tasks.update_all(position: 0)

# Re-run position assignment for specific child
# (Run rake task logic manually for one child)
```

## Rollback Plan

If issues arise, rollback steps:

1. **Revert code deployment** (if possible with your deployment system)

2. **OR Manual rollback:**
```bash
# Create and run rollback migration
RAILS_ENV=production bin/rails generate migration RemovePositionFromTasks
```

Add to the migration:
```ruby
class RemovePositionFromTasks < ActiveRecord::Migration[8.0]
  def change
    remove_index :tasks, [:child_id, :time_of_day, :position, :name]
    remove_column :tasks, :position
  end
end
```

```bash
RAILS_ENV=production bin/rails db:migrate
```

3. **Update Task model** to remove position from ordered scope
4. **Redeploy** without position feature

## Success Criteria

- [ ] All existing tasks maintain their completion status
- [ ] Tasks appear in logical chronological order within time periods
- [ ] No performance degradation in task loading
- [ ] Console commands work for position management
- [ ] No errors in application logs

## Notes

- Position 0 tasks will appear first (alphabetically) before positioned tasks
- The rake task only updates tasks with exact name matches (case-insensitive)
- New tasks created after deployment will default to position 0
- Position management is console-only - no UI for reordering