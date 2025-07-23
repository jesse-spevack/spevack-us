# Implementation Plan: ChoreTracker

**Generated**: 2025-07-22  
**Based on**: Requirements discussion and database design session

## Overview

This plan implements a simple, beautiful chore tracking app for a family with two children. The app prioritizes getting working software on iPads quickly, with a clean interface for kids to mark daily chores complete and parents to view weekly progress.

## Technical Architecture

### Database Schema

```ruby
# children table
- id: integer (PK)
- name: string
- theme: string  # 'default', 'neo-brutalism', 'candy' (future enhancement)
- created_at: datetime
- updated_at: datetime

# tasks table  
- id: integer (PK)
- child_id: integer (FK)
- name: string
- time_of_day: integer  # enum: 0=morning, 1=afternoon, 2=evening
- frequency: string     # 'daily', 'weekend', 'specific_days'
- specific_days: string # '1,3,5' for MWF (when frequency='specific_days')
- active: boolean (default: true)
- created_at: datetime
- updated_at: datetime

# task_completions table
- id: integer (PK)
- task_id: integer (FK)
- completed_on: date
- created_at: datetime
- updated_at: datetime
```

### Key Design Decisions

1. **One task per child**: No task sharing between children for simplicity
2. **Schedule changes**: Update task record directly; completions remain as historical facts
3. **Cookie-based child identification**: Simple, no auth required
4. **Server-side rendering**: Minimal JavaScript, using Turbo for interactions
5. **Clean default theme**: Black on white, Helvetica-style typography

## Implementation Phases

### Phase 1: Minimum Working App [Size: L]

Get a functional chore tracker on iPad as quickly as possible.

#### Tasks

- [x] **1.1 Create database migrations**
  - **Files**: 
    - `db/migrate/001_create_children.rb`
    - `db/migrate/002_create_tasks.rb`
    - `db/migrate/003_create_task_completions.rb`
  - **Implementation Notes**:
    ```ruby
    # 001_create_children.rb
    create_table :children do |t|
      t.string :name, null: false
      t.string :theme, default: 'default'
      t.timestamps
    end

    # 002_create_tasks.rb
    create_table :tasks do |t|
      t.references :child, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :time_of_day, default: 1  # afternoon
      t.string :frequency, default: 'daily'
      t.string :specific_days
      t.boolean :active, default: true
      t.timestamps
    end
    add_index :tasks, [:child_id, :active]
    add_index :tasks, :time_of_day

    # 003_create_task_completions.rb
    create_table :task_completions do |t|
      t.references :task, null: false, foreign_key: true
      t.date :completed_on, null: false
      t.timestamps
    end
    add_index :task_completions, [:task_id, :completed_on], unique: true
    add_index :task_completions, :completed_on
    ```

- [ ] **1.2 Create models with associations**
  - **Files**: 
    - `app/models/child.rb`
    - `app/models/task.rb`
    - `app/models/task_completion.rb`
  - **Implementation Notes**:
    ```ruby
    # app/models/child.rb
    class Child < ApplicationRecord
      has_many :tasks, -> { where(active: true) }, dependent: :destroy
      has_many :task_completions, through: :tasks
      
      validates :name, presence: true, uniqueness: true
    end

    # app/models/task.rb
    class Task < ApplicationRecord
      belongs_to :child
      has_many :task_completions, dependent: :destroy
      
      validates :name, presence: true
      validates :frequency, inclusion: { in: %w[daily weekend specific_days] }
      
      enum time_of_day: { morning: 0, afternoon: 1, evening: 2 }
      
      scope :ordered, -> { order(:time_of_day, :name) }
      
      def due_on?(date)
        case frequency
        when 'daily'
          true
        when 'weekend'
          [0, 6].include?(date.wday)  # Sunday = 0, Saturday = 6
        when 'specific_days'
          return false if specific_days.blank?
          specific_days.split(',').map(&:to_i).include?(date.wday)
        end
      end
      
      def completed_on?(date)
        task_completions.exists?(completed_on: date)
      end
    end

    # app/models/task_completion.rb
    class TaskCompletion < ApplicationRecord
      belongs_to :task
      
      validates :completed_on, presence: true
      validates :task_id, uniqueness: { scope: :completed_on }
    end
    ```

- [ ] **1.3 Create basic routes and controllers**
  - **Files**: 
    - `config/routes.rb`
    - `app/controllers/tasks_controller.rb`
  - **Implementation Notes**:
    ```ruby
    # config/routes.rb
    Rails.application.routes.draw do
      root "tasks#daily"
      
      resources :tasks, only: [] do
        member do
          post :toggle
        end
      end
      
      get "daily(/:date)", to: "tasks#daily", as: :daily_tasks
      
      # Future phases
      # resources :children, only: [:index]
      # get "weekly_review/:child_id", to: "reviews#weekly", as: :weekly_review
    end

    # app/controllers/tasks_controller.rb
    class TasksController < ApplicationController
      def daily
        # Hardcode first child for Phase 1
        @child = Child.first || Child.create!(name: "Test Child")
        @date = params[:date] ? Date.parse(params[:date]) : Date.current
        @tasks = @child.tasks.ordered
        @is_today = @date == Date.current
      end
      
      def toggle
        task = Task.find(params[:id])
        date = Date.parse(params[:date])
        
        completion = task.task_completions.find_by(completed_on: date)
        
        if completion
          completion.destroy!
        else
          task.task_completions.create!(completed_on: date)
        end
        
        redirect_to daily_tasks_path(date: date)
      end
    end
    ```

- [ ] **1.4 Create minimal daily view**
  - **Files**: 
    - `app/views/tasks/daily.html.erb`
    - `app/views/layouts/application.html.erb` (updates)
  - **Implementation Notes**:
    ```erb
    <!-- app/views/tasks/daily.html.erb -->
    <div class="max-w-2xl mx-auto p-4">
      <header class="text-center mb-8">
        <h1 class="text-2xl font-bold mb-4">ChoreTracker</h1>
        <div class="flex items-center justify-center gap-4">
          <%= link_to "←", daily_tasks_path(date: @date - 1), 
              class: "text-2xl px-4 py-2" %>
          <h2 class="text-xl">
            <%= @date.strftime("%A, %B %d") %>
          </h2>
          <%= link_to "→", daily_tasks_path(date: @date + 1), 
              class: "text-2xl px-4 py-2",
              style: (@date >= Date.current ? "visibility: hidden" : "") %>
        </div>
      </header>
      
      <% %w[morning afternoon evening].each do |time_period| %>
        <% tasks_for_period = @tasks.select { |t| t.time_of_day == time_period && t.due_on?(@date) } %>
        <% if tasks_for_period.any? %>
          <section class="mb-8">
            <h3 class="text-lg font-semibold mb-4 capitalize"><%= time_period %></h3>
            <% tasks_for_period.each do |task| %>
              <%= form_with url: toggle_task_path(task, date: @date), 
                          method: :post,
                          class: "task-row" do |f| %>
                <label class="flex items-center gap-4 p-4 border-2 border-black mb-2 cursor-pointer">
                  <input type="checkbox" 
                         <%= 'checked' if task.completed_on?(@date) %>
                         onchange="this.form.submit()"
                         class="w-8 h-8">
                  <span class="text-xl flex-1"><%= task.name %></span>
                </label>
              <% end %>
            <% end %>
          </section>
        <% end %>
      <% end %>
    </div>
    ```

- [ ] **1.5 Add seed data for testing**
  - **Files**: `db/seeds.rb`
  - **Implementation Notes**:
    ```ruby
    # Create children
    eddie = Child.create!(name: "Eddie", theme: "neo-brutalism")
    audrey = Child.create!(name: "Audrey", theme: "candy")
    
    # Eddie's tasks
    Task.create!(child: eddie, name: "Make bed", time_of_day: "morning", frequency: "daily")
    Task.create!(child: eddie, name: "Brush teeth", time_of_day: "morning", frequency: "daily")
    Task.create!(child: eddie, name: "Take out trash", time_of_day: "afternoon", 
                 frequency: "specific_days", specific_days: "1,3,5")
    Task.create!(child: eddie, name: "Do homework", time_of_day: "afternoon", 
                 frequency: "specific_days", specific_days: "1,2,3,4,5")
    Task.create!(child: eddie, name: "Clean room", time_of_day: "afternoon", frequency: "weekend")
    Task.create!(child: eddie, name: "Set table", time_of_day: "evening", frequency: "daily")
    
    # Audrey's tasks (similar pattern)
    Task.create!(child: audrey, name: "Make bed", time_of_day: "morning", frequency: "daily")
    Task.create!(child: audrey, name: "Feed cat", time_of_day: "morning", frequency: "daily")
    Task.create!(child: audrey, name: "Practice piano", time_of_day: "afternoon", 
                 frequency: "specific_days", specific_days: "1,2,3,4,5")
    Task.create!(child: audrey, name: "Clear dishes", time_of_day: "evening", frequency: "daily")
    ```

#### Testing Scenarios
- Task appears correctly based on schedule (daily, weekend, specific days)
- Checkbox state persists after page reload
- Can navigate between days
- Cannot navigate to future dates
- Task completion creates/destroys records correctly

### Phase 2: Make it Usable [Size: M]

Add child selection, improve navigation, and polish the visual design.

#### Tasks

- [ ] **2.1 Add child selection screen**
  - **Files**: 
    - `app/controllers/children_controller.rb`
    - `app/views/children/index.html.erb`
  - **Implementation Notes**:
    ```ruby
    # app/controllers/children_controller.rb
    class ChildrenController < ApplicationController
      def index
        @children = Child.all.order(:name)
      end
      
      def select
        child = Child.find(params[:id])
        cookies[:child_id] = child.id
        redirect_to daily_tasks_path
      end
    end
    ```
    ```erb
    <!-- app/views/children/index.html.erb -->
    <div class="min-h-screen flex items-center justify-center">
      <div class="text-center">
        <h1 class="text-4xl font-bold mb-8">Who are you?</h1>
        <div class="flex gap-8 justify-center">
          <% @children.each do |child| %>
            <%= link_to select_child_path(child), 
                method: :post,
                class: "block p-12 border-4 border-black text-2xl font-semibold hover:bg-gray-100" do %>
              <%= child.name %>
            <% end %>
          <% end %>
        </div>
      </div>
    </div>
    ```

- [ ] **2.2 Add cookie-based child persistence**
  - **Files**: Update `app/controllers/application_controller.rb`, `app/controllers/tasks_controller.rb`
  - **Implementation Notes**:
    ```ruby
    # app/controllers/application_controller.rb
    class ApplicationController < ActionController::Base
      private
      
      def current_child
        @current_child ||= Child.find_by(id: cookies[:child_id])
      end
      
      def require_child
        redirect_to children_path unless current_child
      end
    end
    
    # Update tasks_controller.rb
    before_action :require_child
    
    def daily
      @child = current_child
      # ... rest of method
    end
    ```

- [ ] **2.3 Add "Today" button and improve navigation**
  - **Files**: Update `app/views/tasks/daily.html.erb`
  - **Implementation Notes**: Add conditional "Today" link that only shows when not on current date

- [ ] **2.4 Implement clean default theme**
  - **Files**: 
    - `app/assets/stylesheets/application.tailwind.css`
  - **Implementation Notes**:
    ```css
    @layer base {
      :root {
        --font-sans: system-ui, -apple-system, "Helvetica Neue", Arial, sans-serif;
        --background: white;
        --foreground: black;
        --border: black;
        --radius: 0;
      }
      
      body {
        font-family: var(--font-sans);
        background: var(--background);
        color: var(--foreground);
      }
      
      /* Touch-optimized checkbox styles */
      input[type="checkbox"] {
        width: 44px;
        height: 44px;
        cursor: pointer;
      }
      
      .task-row label {
        min-height: 60px;
        transition: background-color 0.2s;
      }
      
      .task-row label:active {
        background-color: #f5f5f5;
      }
    }
    ```

- [ ] **2.5 Add Turbo for seamless interactions**
  - **Files**: Update controllers and views for Turbo
  - **Implementation Notes**: Convert form submissions to Turbo frames to avoid full page reloads

#### Testing Scenarios
- Child selection persists across page reloads
- Cannot access daily view without selecting child
- Today button appears/disappears correctly
- Visual feedback on touch interactions
- Clean typography and spacing on iPad

### Phase 3: Weekly Review [Size: M]

Implement the weekly summary view for family meetings.

#### Tasks

- [ ] **3.1 Create weekly review controller and view**
  - **Files**: 
    - `app/controllers/reviews_controller.rb`
    - `app/views/reviews/weekly.html.erb`
  - **Implementation Notes**:
    ```ruby
    # app/controllers/reviews_controller.rb
    class ReviewsController < ApplicationController
      def weekly
        @child = Child.find(params[:child_id])
        @week_start = (params[:week_start]&.to_date || Date.current).beginning_of_week
        @week_end = @week_start.end_of_week
        
        @summary = calculate_weekly_summary
      end
      
      private
      
      def calculate_weekly_summary
        total_expected = 0
        total_completed = 0
        task_details = []
        
        @child.tasks.each do |task|
          expected_dates = dates_for_task_in_week(task)
          completed_dates = task.task_completions
                                .where(completed_on: @week_start..@week_end)
                                .pluck(:completed_on)
          
          expected_count = expected_dates.count
          completed_count = completed_dates.count
          
          total_expected += expected_count
          total_completed += completed_count
          
          task_details << {
            task: task,
            expected: expected_count,
            completed: completed_count,
            percentage: expected_count > 0 ? (completed_count * 100.0 / expected_count).round : 100,
            missing_dates: expected_dates - completed_dates
          }
        end
        
        {
          total_expected: total_expected,
          total_completed: total_completed,
          overall_percentage: total_expected > 0 ? (total_completed * 100.0 / total_expected).round : 100,
          perfect_tasks: task_details.select { |t| t[:percentage] == 100 },
          incomplete_tasks: task_details.select { |t| t[:percentage] < 100 }.sort_by { |t| -t[:percentage] }
        }
      end
      
      def dates_for_task_in_week(task)
        (@week_start..@week_end).select { |date| task.due_on?(date) }
      end
    end
    ```

- [ ] **3.2 Create clean weekly review layout**
  - **Files**: `app/views/reviews/weekly.html.erb`
  - **Implementation Notes**:
    ```erb
    <div class="max-w-2xl mx-auto p-4">
      <header class="text-center mb-8">
        <h1 class="text-2xl font-bold">ChoreTracker</h1>
        <h2 class="text-xl mt-2"><%= @child.name %>'s Week in Review</h2>
        <p class="text-gray-600 mt-1">
          <%= @week_start.strftime("%B %d") %> - <%= @week_end.strftime("%d, %Y") %>
        </p>
      </header>
      
      <section class="mb-8 p-6 border-2 border-black">
        <h3 class="text-lg font-semibold mb-4">Overview</h3>
        <div class="space-y-2 text-lg">
          <p>Tasks Assigned: <strong><%= @summary[:total_expected] %></strong></p>
          <p>Tasks Completed: <strong><%= @summary[:total_completed] %></strong></p>
          <p>Completion Rate: <strong><%= @summary[:overall_percentage] %>%</strong></p>
        </div>
      </section>
      
      <% if @summary[:perfect_tasks].any? %>
        <section class="mb-8">
          <h3 class="text-lg font-semibold mb-4">Perfectly Done (100%)</h3>
          <ul class="space-y-1">
            <% @summary[:perfect_tasks].each do |task_info| %>
              <li class="text-lg">✓ <%= task_info[:task].name %></li>
            <% end %>
          </ul>
        </section>
      <% end %>
      
      <% if @summary[:incomplete_tasks].any? %>
        <section class="mb-8">
          <h3 class="text-lg font-semibold mb-4">Needs Attention</h3>
          <ul class="space-y-2">
            <% @summary[:incomplete_tasks].each do |task_info| %>
              <li class="text-lg">
                <%= task_info[:task].name %>
                <span class="text-gray-600">
                  (<%= task_info[:completed] %> of <%= task_info[:expected] %> - <%= task_info[:percentage] %>%)
                </span>
              </li>
            <% end %>
          </ul>
        </section>
      <% end %>
    </div>
    ```

- [ ] **3.3 Add navigation to weekly review**
  - **Files**: Update daily view and routes
  - **Implementation Notes**: Add link from daily view to weekly review

#### Testing Scenarios
- Correct calculation of expected tasks based on schedules
- Accurate completion percentages
- Tasks sorted by completion percentage in "Needs Attention"
- Clean, readable layout for family discussions
- Works for edge cases (no tasks, 100% completion, 0% completion)

### Phase 4: Task Management [Size: L]

Create console helpers for easy task creation and management.

#### Tasks

- [ ] **4.1 Create task management helpers**
  - **Files**: `lib/tasks/chores.rake`
  - **Implementation Notes**:
    ```ruby
    namespace :chores do
      desc "Interactive task creation"
      task create: :environment do
        # Simple version first
        puts "Creating a new task"
        puts "=================="
        
        # Select child
        children = Child.order(:name)
        puts "\nSelect a child:"
        children.each_with_index do |child, i|
          puts "#{i + 1}. #{child.name}"
        end
        print "Choice: "
        child_index = STDIN.gets.chomp.to_i - 1
        child = children[child_index]
        
        # Task name
        print "\nTask name: "
        name = STDIN.gets.chomp
        
        # Time of day
        puts "\nWhen should this task be done?"
        puts "1. Morning"
        puts "2. Afternoon"
        puts "3. Evening"
        print "Choice (default: 2): "
        time_choice = STDIN.gets.chomp
        time_of_day = case time_choice
                      when "1" then "morning"
                      when "3" then "evening"
                      else "afternoon"
                      end
        
        # Schedule
        puts "\nHow often?"
        puts "1. Every day"
        puts "2. Weekends only"
        puts "3. Specific days"
        print "Choice: "
        schedule_choice = STDIN.gets.chomp
        
        frequency, specific_days = case schedule_choice
        when "2"
          ["weekend", nil]
        when "3"
          puts "Enter days (0=Sun, 1=Mon, etc.), comma-separated: "
          days = STDIN.gets.chomp
          ["specific_days", days]
        else
          ["daily", nil]
        end
        
        # Create task
        task = Task.create!(
          child: child,
          name: name,
          time_of_day: time_of_day,
          frequency: frequency,
          specific_days: specific_days
        )
        
        puts "\n✓ Created task: #{task.name} for #{child.name}"
      end
      
      desc "List all tasks"
      task list: :environment do
        Child.order(:name).each do |child|
          puts "\n#{child.name}'s Tasks:"
          puts "==================="
          child.tasks.ordered.each do |task|
            schedule = case task.frequency
                      when "daily" then "every day"
                      when "weekend" then "weekends"
                      when "specific_days" then "on #{task.specific_days}"
                      end
            puts "- #{task.name} (#{task.time_of_day}, #{schedule})"
          end
        end
      end
    end
    ```

- [ ] **4.2 Add quick helper methods**
  - **Files**: `app/models/child.rb`, `app/models/task.rb`
  - **Implementation Notes**:
    ```ruby
    # app/models/child.rb
    def add_daily_task(name, time_of_day = :afternoon)
      tasks.create!(name: name, time_of_day: time_of_day, frequency: 'daily')
    end
    
    def add_weekend_task(name, time_of_day = :afternoon)
      tasks.create!(name: name, time_of_day: time_of_day, frequency: 'weekend')
    end
    
    def add_weekday_task(name, days, time_of_day = :afternoon)
      tasks.create!(
        name: name, 
        time_of_day: time_of_day, 
        frequency: 'specific_days',
        specific_days: days.is_a?(Array) ? days.join(',') : days
      )
    end
    ```

- [ ] **4.3 Document console usage**
  - **Files**: Update `README.md`
  - **Implementation Notes**: Add section with common console commands

#### Testing Scenarios
- Can create tasks with all schedule types
- Rake task handles invalid input gracefully
- Helper methods create valid tasks
- Tasks appear correctly in daily view after creation

### Phase 5: Polish & Error Handling [Size: S]

Add error handling and edge case management.

#### Tasks

- [ ] **5.1 Add error message display**
  - **Files**: Update views and controllers
  - **Implementation Notes**:
    ```erb
    <!-- In application layout -->
    <% if flash[:error] %>
      <div class="fixed bottom-4 left-4 right-4 bg-black text-white p-4 max-w-md mx-auto">
        <%= flash[:error] %>
      </div>
    <% end %>
    ```

- [ ] **5.2 Handle edge cases**
  - **Implementation Notes**:
    - No tasks for a day
    - No children in system
    - Invalid date navigation
    - Task completion toggle failures

- [ ] **5.3 Add basic logging**
  - **Implementation Notes**: Log task completions for debugging

#### Testing Scenarios
- Error messages appear and disappear correctly
- App handles missing data gracefully
- Navigation boundaries enforced
- Logging captures important events

### Phase 6: Theme System [Size: M]

Add individual themes for each child.

#### Tasks

- [ ] **6.1 Implement theme switching**
  - **Files**: Update `app/views/layouts/application.html.erb`
  - **Implementation Notes**:
    ```erb
    <body class="theme-<%= current_child&.theme || 'default' %>">
    ```

- [ ] **6.2 Add neo-brutalism theme for Eddie**
  - **Files**: `app/assets/stylesheets/themes/neo_brutalism.css`
  - **Implementation Notes**: Use the color scheme and shadows from discussion

- [ ] **6.3 Add candy theme for Audrey**
  - **Files**: `app/assets/stylesheets/themes/candy.css`
  - **Implementation Notes**: Use the softer colors and rounded corners

#### Testing Scenarios
- Theme switches when child changes
- All UI elements respect theme variables
- Themes work correctly on iPad

## Console Task Creation Examples

```ruby
# Quick task creation
eddie = Child.find_by(name: "Eddie")
eddie.add_daily_task("Make bed", :morning)
eddie.add_weekday_task("Take out trash", "1,3,5", :afternoon)  # MWF
eddie.add_weekend_task("Clean room", :afternoon)

# Using rake task
rake chores:create  # Interactive prompt
rake chores:list    # See all tasks

# Direct creation
Task.create!(
  child: eddie,
  name: "Do homework",
  time_of_day: "afternoon",
  frequency: "specific_days",
  specific_days: "1,2,3,4,5"  # Weekdays
)

# Modify existing
task = eddie.tasks.find_by(name: "Take out trash")
task.update!(frequency: "daily")  # Change schedule

# Deactivate task
task.update!(active: false)
```

## Technical Notes

### Performance Considerations
- Index on `tasks.child_id` and `tasks.active` for daily view queries
- Index on `task_completions.completed_on` for date-based queries
- Unique index on `[task_id, completed_on]` prevents duplicate completions

### Security Notes
- No authentication required (family trust model)
- No sensitive data stored
- Cookie-based child identification is sufficient

### Browser Compatibility
- Target: Modern iPad Safari
- Touch-optimized with 44px minimum touch targets
- Works without JavaScript (Turbo progressive enhancement)

### Deployment Notes
- SQLite for development/simple deployment
- Can migrate to PostgreSQL without code changes
- Static asset compilation for production

## Next Steps

1. Run migrations and seed initial data
2. Test on actual iPad device early
3. Get family feedback on Phase 1 before continuing
4. Iterate based on real usage patterns

## Relevant Files

### Database Migrations
- `db/migrate/20250723123038_create_children.rb` - Creates children table with name and theme fields
- `db/migrate/20250723123421_create_tasks.rb` - Creates tasks table with time_of_day, frequency, and child association
- `db/migrate/20250723123432_create_task_completions.rb` - Creates task_completions table for tracking completed tasks