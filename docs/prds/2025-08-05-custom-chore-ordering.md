# Custom Chore Ordering Within Time Periods
*Product Requirements Document*
*Date: 2025-08-05*

## 1. Vision & Story

### User Story
Every morning, Emma watches her 7-year-old son Jake struggle with his chore list. Despite grouping tasks by morning, afternoon, and evening, the alphabetical ordering within each group creates confusion. "Brush teeth" appears before "Get dressed," leading Jake to run back and forth between rooms. He gets frustrated, loses momentum, and what should be a smooth 15-minute routine stretches to 30 minutes of chaos.

With custom ordering, Emma arranges Jake's morning tasks in a logical flow: Get dressed → Make bed → Brush teeth → Pack backpack. Now Jake moves efficiently from bedroom to bathroom to kitchen, checking off tasks in a natural sequence. His morning routine becomes a satisfying progression rather than a scattered scramble.

### Before/After Scenario
**Before**: Children see alphabetically ordered tasks within time periods, causing inefficient back-and-forth movement and confusion about task flow.

**After**: Parents can order tasks within each time period to match the child's natural movement through the house and logical task progression, creating a smooth chronological flow.

### Value Proposition
Transform chaotic chore completion into efficient, logical progressions that match how children naturally move through their day.

### Emotional Hook
Replace the frustration of illogical task ordering with the satisfaction of a smooth, sequential workflow that children can complete without constant redirection.

## 2. Problem & Goals

### Problem Statement
Currently, tasks within each time period (morning, afternoon, evening) are sorted alphabetically by name. This creates inefficient workflows where children must:
- Jump between different rooms unnecessarily (bathroom → bedroom → bathroom)
- Complete tasks out of logical sequence (pack lunch before eating breakfast)
- Lose momentum and focus due to scattered task locations

### Success Metrics
- **Efficiency**: Tasks appear in logical chronological order
- **Simplicity**: Order can be set via Rails console commands
- **Persistence**: Order remains consistent across all views

### Primary Goals
1. Add position field to tasks for custom ordering within time periods
2. Provide Rails console methods to set task positions
3. Create one-time migration to set initial positions for existing tasks

## 3. User Stories & Experience

### Primary User Stories

**Admin Story**
As an admin, I want to set custom positions for tasks via Rails console so children see them in logical chronological order within each time period.

**Child User Story**
As a child, I want to see my chores in an order that makes sense so I can work through them efficiently without getting confused or having to backtrack.

### User Flows

**Setting Task Order (Admin via Console)**
```ruby
# Set specific position for a task
task = Task.find_by(name: "brush teeth", child: child)
task.update!(position: 30)

# Reorder all morning tasks for a child
child.tasks.morning.update_all(position: 100)  # Reset all
child.tasks.find_by(name: "get dressed").update!(position: 10)
child.tasks.find_by(name: "make bed").update!(position: 20)
child.tasks.find_by(name: "brush teeth").update!(position: 30)
```

**Viewing Ordered Tasks (Child)**
1. Child logs in and sees daily task view
2. Tasks appear grouped by time period
3. Within each period, tasks display in position order
4. Same order appears in weekly review

### Acceptance Criteria
- [ ] Tasks have position field that determines order within time period
- [ ] Tasks sort by time_of_day, then position, then name
- [ ] Migration sets initial positions based on desired order
- [ ] Console commands allow position updates
- [ ] Order persists across all views

## 4. Functional Requirements

### Core Features

**F1: Position Attribute**
- Add integer `position` column to tasks table with default 0
- Position determines sort order within time_of_day groups
- No uniqueness constraint (allows easy reordering)

**F2: Ordering Logic**
- Modify Task model's `ordered` scope to: `order(:time_of_day, :position, :name)`
- Position 0 items sort alphabetically after positioned items
- Name acts as final tiebreaker

**F3: Migration/Rake Task**
- One-time migration to add position column
- Rake task to set initial positions for production data
- Positions set based on logical task flow (hardcoded mapping)

### Business Logic

**Ordering Rules**
- Tasks sort by: time_of_day (morning=0, afternoon=1, evening=2)
- Within time period: position (ascending), then name (alphabetical)
- Position 0 = default (sorted alphabetically after positioned tasks)

**Position Guidelines**
- Use increments of 10 (10, 20, 30) for easy insertions
- No automatic reordering on insert/delete
- Admin manually manages all positions

### Technical Integration

**Database Migration**
```ruby
class AddPositionToTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :position, :integer, default: 0, null: false
    add_index :tasks, [:child_id, :time_of_day, :position, :name]
  end
end
```

**Model Update**
```ruby
# app/models/task.rb
scope :ordered, -> { order(:time_of_day, :position, :name) }
```

**Rake Task for Initial Positions**
```ruby
# lib/tasks/set_task_positions.rake
namespace :tasks do
  desc "Set initial positions for all tasks"
  task set_positions: :environment do
    # Hardcoded position mappings per child
    position_map = {
      "morning" => {
        "get dressed" => 10,
        "make bed" => 20,
        "brush teeth" => 30,
        "hair" => 40,
        # etc.
      },
      "afternoon" => {
        # mappings
      },
      "evening" => {
        # mappings
      }
    }
    
    Child.find_each do |child|
      position_map.each do |time_period, tasks|
        tasks.each do |task_name, position|
          child.tasks.where(time_of_day: time_period)
                     .where("LOWER(name) = ?", task_name.downcase)
                     .update_all(position: position)
        end
      end
    end
  end
end
```

### Performance & Security
- Index on [child_id, time_of_day, position, name] for fast queries
- No UI exposure = no security concerns
- Simple integer field with minimal overhead

## 5. Scope & Boundaries

### In Scope
- Position field on tasks table
- Updated ordering logic in Task model
- Rails console interface for setting positions
- One-time migration and rake task for production

### Out of Scope
- Any UI for reordering
- Automatic position management
- Position uniqueness or gap maintenance
- Backwards compatibility
- Cross-child position copying

### Future Considerations
- Potential drag-and-drop UI (not planned)
- Position templates (not planned)
- Automatic position assignment for new tasks

### Dependencies
- Existing Task model with time_of_day enum
- Current ordered scope to be modified
- Rails console access for position management

## 6. Success Validation

### Launch Criteria
- [ ] Migration adds position field successfully
- [ ] Ordered scope uses new sort order
- [ ] Rake task sets positions for all existing tasks
- [ ] Tasks appear in logical order in daily view
- [ ] Console commands work for position updates

### Risk Assessment

**Technical Risks**
- **Migration failure**: Simple column addition, very low risk
- **Sort performance**: Covered by composite index

**Business Risks**
- **Wrong initial positions**: Can be corrected via console
- **Missing tasks in mapping**: Will default to position 0 (alphabetical)

### Open Questions
None - requirements are clear and implementation is straightforward.

## Implementation Notes

### Console Commands
```ruby
# View current positions
Child.first.tasks.morning.ordered.pluck(:name, :position)

# Set position for specific task
task = Task.find(123)
task.update!(position: 25)

# Bulk update positions
tasks = Child.first.tasks.morning
tasks.find_by(name: "get dressed").update!(position: 10)
tasks.find_by(name: "make bed").update!(position: 20)
tasks.find_by(name: "brush teeth").update!(position: 30)
```

### Deployment Steps
1. Deploy code with migration and model changes
2. Run migration: `rails db:migrate`
3. Run rake task: `rails tasks:set_positions`
4. Verify in console: `Child.first.tasks.morning.ordered.pluck(:name, :position)`