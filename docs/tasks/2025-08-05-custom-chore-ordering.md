# Task List: Custom Chore Ordering Within Time Periods

**Generated**: 2025-08-05  
**Based on PRD**: 2025-08-05-custom-chore-ordering.md  
**Estimated Total**: 1-2 days

## Architecture Overview

This feature adds a position-based ordering system for tasks within time periods. The implementation consists of:
- Database migration to add `position` column to tasks table
- Model update to modify the `ordered` scope
- Rake task for setting initial positions on existing data
- Console-based interface for position management

No UI changes are required - the existing views will automatically use the new ordering.

## File Planning

### New Files
- `db/migrate/[timestamp]_add_position_to_tasks.rb` - Migration to add position column and index
- `lib/tasks/set_task_positions.rake` - Rake task for initial position assignment
- `test/models/task_position_test.rb` - Unit tests for position-based ordering

### Modified Files  
- `app/models/task.rb` - Update ordered scope to include position
- `test/models/task_test.rb` - Update existing tests for new ordering

## Implementation Tasks

### Phase 1: Database Foundation (P0)
- [ ] **1.1** Create and run database migration `[Simple]`
  - **Dependencies**: None
  - **Files**: `db/migrate/[timestamp]_add_position_to_tasks.rb`
  - **Implementation**:
    ```ruby
    class AddPositionToTasks < ActiveRecord::Migration[8.0]
      def change
        add_column :tasks, :position, :integer, default: 0, null: false
        add_index :tasks, [:child_id, :time_of_day, :position, :name]
      end
    end
    ```
  - **Testing**: Verify migration runs successfully, check schema.rb
  - **Verification**: `rails db:migrate:status`, inspect db/schema.rb

### Phase 2: Model Updates (P0)
- [ ] **2.1** Update Task model ordered scope `[Simple]`
  - **Dependencies**: Requires 1.1 (migration complete)
  - **Files**: `app/models/task.rb`
  - **Changes**: 
    - Update line 14: `scope :ordered, -> { order(:time_of_day, :position, :name) }`
  - **Testing**: Rails console verification
  - **Verification Commands**:
    ```ruby
    Task.ordered.to_sql  # Should show ORDER BY with position
    Child.first.active_tasks.pluck(:name, :position)
    ```

### Phase 3: Position Management (P1)
- [ ] **3.1** Create rake task for initial position setup `[Medium]`
  - **Dependencies**: Requires 2.1
  - **Files**: `lib/tasks/set_task_positions.rake`
  - **Implementation**: Create comprehensive position mappings for all known tasks
  - **Testing**: Run on test database first
  - **Key mappings to include**:
    - Morning: get dressed (10), make bed (20), brush teeth (30), hair (40)
    - Afternoon: homework (10), practice instrument (20), chores (30)
    - Evening: pajamas (10), brush teeth (20), pack backpack (30)

- [ ] **3.2** Document console commands for position management `[Simple]`
  - **Dependencies**: None
  - **Files**: Update CLAUDE.md or README
  - **Documentation**: Add section with common position management commands
  - **Examples to include**:
    ```ruby
    # View positions
    Child.find_by(name: "Jake").tasks.morning.ordered.pluck(:name, :position)
    
    # Update single task
    task = Task.find_by(name: "brush teeth", child: child)
    task.update!(position: 30)
    
    # Bulk reorder
    child.tasks.morning.find_by(name: "get dressed").update!(position: 10)
    child.tasks.morning.find_by(name: "make bed").update!(position: 20)
    ```

### Phase 4: Testing & Validation (P1)
- [ ] **4.1** Write unit tests for position-based ordering `[Medium]`
  - **Dependencies**: Requires 2.1
  - **Files**: `test/models/task_position_test.rb`
  - **Test cases**:
    - Tasks sort by position within time period
    - Position 0 tasks sort alphabetically after positioned tasks
    - Ordering persists across different query methods
    - Name acts as tiebreaker for same position

- [ ] **4.2** Update existing task tests `[Simple]`
  - **Dependencies**: Requires 2.1
  - **Files**: `test/models/task_test.rb`
  - **Changes**: Update any tests that depend on alphabetical ordering
  - **Testing**: `rails test test/models/task_test.rb`

### Phase 5: Production Deployment (P0)
- [ ] **5.1** Test rake task with production-like data `[Simple]`
  - **Dependencies**: Requires 3.1
  - **Testing**: Create test children with various tasks, run rake task
  - **Verification**: Ensure all tasks get appropriate positions

- [ ] **5.2** Create deployment checklist `[Simple]`
  - **Dependencies**: All previous tasks
  - **Deliverable**: Step-by-step deployment guide
  - **Contents**:
    1. Deploy code changes
    2. Run migration: `rails db:migrate`
    3. Verify schema: `rails db:migrate:status`
    4. Run rake task: `rails tasks:set_positions`
    5. Console verification of positions
    6. Spot check UI for correct ordering

## Development Notes

### Testing Strategy
- **Unit tests**: Focus on ordering logic with various position values
- **Integration tests**: Verify ordering works through associations (child.active_tasks)
- **Manual testing**: Use console to verify real data ordering

### Key Considerations
- **Position gaps**: Use increments of 10 to allow easy insertions
- **Default behavior**: Position 0 maintains backward compatibility
- **No auto-management**: Positions are manually set only
- **Index performance**: Composite index ensures fast queries

### Console Testing Commands
```ruby
# After migration
Task.column_names.include?("position")  # => true

# After scope update
Child.first.active_tasks.to_sql  # Check ORDER BY clause

# After rake task
Child.find_each do |child|
  puts "#{child.name}:"
  child.tasks.morning.ordered.pluck(:name, :position).each do |name, pos|
    puts "  #{pos}: #{name}"
  end
end

# Test ordering
child = Child.first
child.tasks.create!(name: "test task", time_of_day: "morning", position: 25)
child.tasks.morning.ordered.pluck(:name)  # Should show in correct position
```

### Common Issues & Solutions
- **Migration rollback**: `remove_column :tasks, :position` and `remove_index` on composite
- **Wrong positions**: Use console to manually correct
- **Missing tasks in rake**: Will default to position 0 (alphabetical)

### Production Data Considerations
- Run `rails tasks:set_positions RAILS_ENV=production` 
- Monitor for any tasks not in the position mapping
- Have console commands ready for quick position adjustments