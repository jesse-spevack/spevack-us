# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Ruby on Rails 8.0.2 application called ChoreTracker. It's a fresh Rails application with minimal custom code - currently only containing the default Rails scaffolding and configuration.

## Development Commands

### Server and Development
- `bin/rails server` - Start the Rails development server
- `bin/dev` or `foreman start -f Procfile.dev` - Start development server with Tailwind CSS watching
- `bin/rails tailwindcss:watch` - Watch and rebuild Tailwind CSS on changes

### Database
- `bin/rails db:create` - Create development and test databases
- `bin/rails db:migrate` - Run pending migrations
- `bin/rails db:prepare` - Setup database (create if needed, run migrations)
- `bin/rails db:reset` - Drop, recreate, and seed databases

### Testing
- `bin/rails test` - Run all tests except system tests
- `bin/rails test:db` - Reset database and run tests

### Code Quality
- `bundle exec rubocop` - Run Ruby linting (rubocop-rails-omakase)
- `bundle exec brakeman` - Run security analysis

### Assets
- `bin/rails assets:precompile` - Compile assets for production
- `bin/rails tailwindcss:build` - Build Tailwind CSS

## Architecture

### Technology Stack
- **Framework**: Ruby on Rails 8.0.2
- **Database**: SQLite3 (development), configurable for production
- **Frontend**: Hotwire (Turbo + Stimulus), Tailwind CSS
- **Asset Pipeline**: Propshaft with Importmap
- **Job Queue**: Solid Queue
- **Cache**: Solid Cache  
- **WebSocket**: Solid Cable

### Key Directories
- `app/models/` - ActiveRecord models (Child, Task, TaskCompletion)
- `app/controllers/` - Controllers (Application, Tasks, TaskCompletions, Children)
- `app/views/` - ERB templates and layouts
- `app/javascript/` - Stimulus controllers and JavaScript
- `config/` - Rails configuration files
- `db/` - Database migrations and seeds
- `test/` - Test files (using Rails default testing)

### Current State
This application has implemented Phase 1 (minimum working app) and Phase 2.1-2.2 (child selection with cookie persistence). It includes:
- Complete database schema for children, tasks, and task_completions
- Working daily task view with completion tracking
- Child selection screen with cookie-based authentication
- RESTful controllers and proper test coverage
- Basic Tailwind styling optimized for iPad touch targets

## Development Philosophy

### MVP/Steel Thread First
- Always ask: "What gets working software on the device fastest?"
- Hardcode before abstracting (e.g., hardcode first child before building selection)
- Console commands are fine for admin tasks - don't build UI until needed

### Explicit Non-Requirements
- No gamification, points, or rewards
- No character/behavioral tracking beyond completion
- No multi-family support
- No authentication beyond simple cookies

### UI/UX Principles
- Server-side rendering preferred over complex JavaScript
- One-click actions only (no multi-step flows)
- Clean, minimal design - think Helvetica and black borders
- Touch targets minimum 44px for iPad

### Development Approach
- Direct ActiveRecord use in console preferred over complex admin UI
- Create working implementation plan before writing code
- Include concrete code examples in plans
- T-shirt sizing over time estimates

### Common Patterns
- Tasks belong to one child (no sharing)
- Soft delete with `active` flag for schedule changes
- Time-based ordering (morning/afternoon/evening)

### Testing Philosophy
- Focus on happy path and core user journeys
- Skip edge case testing in early phases
- Manual iPad testing over automated browser tests

### Console Task Creation
- Rake tasks or Rails console for admin operations
- Document common commands in README
- REPL-style interfaces only if significantly better than direct commands

### Timezone Handling
The application uses server-side timezone support to ensure dates display correctly for users:

```ruby
# Timezone is automatically detected and stored in a cookie
# Rails handles all timezone conversions server-side

# In ApplicationController
before_action :set_user_timezone

def set_user_timezone
  Time.zone = cookies[:timezone] || "UTC"
end

# Date parsing respects user timezone
def set_date
  @date = params[:date].present? ? Time.zone.parse(params[:date]).to_date : Time.zone.today
end

# Check if date is "today" in user's timezone
@is_today = @date == Time.zone.today
```

Timezone guidelines:
- Browser timezone is detected once via minimal JavaScript
- Stored in permanent cookie (1 year expiration)
- No page reloads for existing users
- Falls back to UTC if detection fails
- All dates stored as UTC in database

### Task Position Management
Tasks can be ordered within time periods using the position field:

```ruby
# View current positions for a child
child = Child.find_by(name: "Jake")
child.tasks.morning.ordered.pluck(:name, :position)

# Update single task position
task = Task.find_by(name: "brush teeth", child: child)
task.update!(position: 30)

# Bulk reorder tasks for a time period
child.tasks.morning.find_by(name: "get dressed").update!(position: 10)
child.tasks.morning.find_by(name: "make bed").update!(position: 20)
child.tasks.morning.find_by(name: "brush teeth").update!(position: 30)
child.tasks.morning.find_by(name: "pack bag").update!(position: 40)

# Reset all positions to alphabetical (position 0)
child.tasks.update_all(position: 0)

# Run rake task to set positions for all children
bin/rails tasks:set_positions
```

Position guidelines:
- Use increments of 10 to allow easy insertions
- Position 0 tasks sort alphabetically after positioned tasks
- No automatic reordering on insert/delete
- Positions are managed manually via console

### Feature Prioritization
- Daily task view → Weekly review → Task creation → Themes
- Beautiful defaults before customization
- Working on iPad is the primary success metric

### Git Workflow
- Create feature branches at the START of implementing a phase/feature
- Use descriptive branch names like `feature/phase-1-minimum-working-app`
- Commit after each completed sub-task with descriptive messages
- Run tests before committing (when tests exist)

### Development Best Practices
- Create feature branch BEFORE starting any code changes
- Write basic happy path unit tests when creating models/controllers
- Verify database changes after migrations (check schema.rb, run migrate:status)
- Note discrepancies between plans and actual implementation (e.g., migration filenames)
- Keep implementation plan updated with actual file paths and any deviations
- Run linting before committing: `bundle exec rubocop`

### Rails-Specific Guidelines
- **RESTful architecture**: Always use RESTful routes and controllers
  ```ruby
  # GOOD - RESTful routes
  resources :tasks, only: [:index] do
    resources :task_completions, only: [:create, :destroy]
  end
  
  # BAD - custom action routes
  resources :tasks do
    member { post :toggle }
  end
  ```
- **Cookie-based authentication**: Use simple cookie persistence for child selection
  ```ruby
  # ApplicationController pattern
  def current_child
    @current_child ||= Child.find_by(id: session[:child_id])
  end

  def require_child
    redirect_to new_session_path unless current_child
  end
  ```
- **Controller organization**: Keep controllers thin, move logic to models and before_actions
  ```ruby
  # GOOD - thin controller with before_actions
  class TasksController < ApplicationController
    before_action :set_child
    before_action :set_date
    
    def index
      @tasks = @child.active_tasks
    end
    
    private
    
    def set_child
      @child = Child.first
    end
  end
  
  # BAD - fat controller with inline logic
  class TasksController < ApplicationController
    def index
      @child = Child.first || Child.create!(name: "Test")
      @date = params[:date] ? Date.parse(params[:date]) : Date.current
      @tasks = @child.active_tasks.ordered
    end
  end
  ```
- **Model methods**: Extract complex queries and logic to model methods
  ```ruby
  # GOOD - logic in model
  class Task < ApplicationRecord
    def task_completion_for_day(date)
      task_completions.find_by(completed_on: date)
    end
  end
  
  # BAD - logic in controller
  completion = task.task_completions.find_by(completed_on: date)
  ```
- **Association scopes**: Include commonly used scopes in associations
  ```ruby
  # GOOD - ordered scope included in association
  has_many :active_tasks, -> { where(active: true).ordered }, class_name: 'Task'
  
  # BAD - calling scope separately
  has_many :active_tasks, -> { where(active: true) }, class_name: 'Task'
  # Then calling: @child.active_tasks.ordered
  ```
- **Enum syntax**: Use Rails 7+ syntax: `enum :attribute_name, { value1: 0, value2: 1 }`
- **Associations with scopes**: Separate filtered associations from base associations
  ```ruby
  # GOOD - allows proper cascading deletes
  has_many :tasks, dependent: :destroy
  has_many :active_tasks, -> { where(active: true) }, class_name: 'Task'
  
  # BAD - orphans inactive records
  has_many :tasks, -> { where(active: true) }, dependent: :destroy
  ```
- **Test-driven development**: Write basic happy path tests for models and controllers
  ```ruby
  # Basic happy path test example
  def test_valid_model_with_required_attributes
    model = Model.new(required_field: "value")
    assert model.valid?
  end
  ```
- **Test authentication patterns**: Handle cookie-based authentication in tests
  ```ruby
  # Setup method for controller tests requiring child authentication
  def setup
    post select_child_path(children(:eddie))
  end
  
  # Separate test class for redirect testing
  class ControllerRedirectTest < ActionDispatch::IntegrationTest
    def test_redirects_when_no_child_selected
      get protected_path
      assert_redirected_to children_path
    end
  end
  ```
- **Console verification**: Use `rails console` to experiment and verify behavior
  ```ruby
  # Console for experimentation
  c = Child.create!(name: "Test")
  t = c.tasks.create!(name: "Test task", frequency: "daily")
  t.completed_on?(Date.current)  # Test methods work
  ```
- **Database constraints**: Match model validations with database constraints when critical
- **Implementation plans**: Always verify syntax against Rails 8.0.2 documentation
- **Code readability**: Add blank lines after guard clauses for better readability
  ```ruby
  # GOOD - blank line after guard clause
  def process(value)
    return nil if value.blank?

    value.upcase
  end
  
  # BAD - no separation
  def process(value)
    return nil if value.blank?
    value.upcase
  end
  ```
- **Constants over magic numbers**: Define constants for magic numbers
  ```ruby
  # GOOD
  SATURDAY = 6
  SUNDAY = 0
  WEEKEND = [ SATURDAY, SUNDAY ].freeze
  
  # BAD
  [ 0, 6 ].include?(date.wday)
  ```

### Pre-Commit Checklist
Before committing Rails changes:
1. Run `rails db:migrate:status` to verify migration state
2. Run `rails test` for affected models/controllers
3. Run `bundle exec rubocop` to check code style
4. Check `db/schema.rb` reflects expected changes
5. Verify no deprecation warnings in server/console output