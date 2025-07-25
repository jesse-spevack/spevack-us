# ChoreTracker

A simple, beautiful chore tracking app for families. Built with Rails 8 and designed for kids to easily track daily tasks on iPads.

## Overview

ChoreTracker helps families manage children's chores without the complexity of gamification or rewards. Kids can check off completed tasks on a clean, touch-friendly interface, while parents can review weekly progress during family meetings.

## Features

- **Simple daily task view** - Kids see only today's tasks, organized by time of day
- **One-click completion** - Large, touch-friendly checkboxes for iPad use
- **Weekly summaries** - Clean reports showing completion rates for family discussions
- **Flexible scheduling** - Daily, weekend-only, or specific day tasks
- **Child-specific tasks** - Each child has their own task list
- **No authentication** - Simple cookie-based child selection

## Setup

### Prerequisites

- Ruby 3.3.0+
- Rails 8.0.2
- SQLite3

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd chore_tracker

# Install dependencies
bundle install

# Setup database
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed

# Start the server
bin/dev
```

Visit http://localhost:3000 to see the app.

## Usage

### Creating Tasks (Console)

The easiest way to create tasks is through the Rails console:

```ruby
# Quick task creation using helper methods
eddie = Child.find_by(name: "Eddie")
eddie.add_daily_task("Make bed", :morning)
eddie.add_weekday_task("Take out trash", "1,3,5", :afternoon)  # MWF
eddie.add_weekend_task("Clean room", :afternoon)

# More examples with helper methods
audrey = Child.find_by(name: "Audrey")
audrey.add_daily_task("Feed cat", :morning)
audrey.add_daily_task("Clear dishes", :evening)
audrey.add_weekday_task("Practice piano", "1,2,3,4,5", :afternoon)  # Weekdays

# Using the interactive task creator
# Development: bin/rails chores:create
# Production: kamal shell -c "bin/rails chores:create"
bin/rails chores:create

# Direct creation for more control
Task.create!(
  child: eddie,
  name: "Do homework",
  time_of_day: "afternoon",
  frequency: "specific_days",
  specific_days: "1,2,3,4,5"  # Weekdays
)
```

### Daily Use

1. Child opens the app and selects their name
2. They see today's tasks organized by morning, afternoon, and evening
3. As they complete tasks, they tap to check them off
4. Parents can review weekly progress from the weekly summary view

## Development

### Running Tests

```bash
bin/rails test
```

### Code Quality

```bash
bundle exec rubocop
bundle exec brakeman
```

### Console Commands

For development, run these commands directly:

```bash
# List all tasks
bin/rails chores:list

# Create a task interactively
bin/rails chores:create
```

For production (using Kamal deployment), prefix with kamal shell:

```bash
# List all tasks in production
kamal shell -c "bin/rails chores:list"

# Create a task interactively in production
kamal shell -c "bin/rails chores:create"
```

For direct model manipulation (development or production console):

```ruby

# Direct task creation
Task.create!(
  child: Child.find_by(name: "Audrey"),
  name: "Feed cat",
  time_of_day: "morning",
  frequency: "daily"
)

# Create task with specific days (weekdays)
Task.create!(
  child: eddie,
  name: "Do homework",
  time_of_day: "afternoon",
  frequency: "specific_days",
  specific_days: "1,2,3,4,5"  # Monday through Friday
)

# Modify existing task
task = eddie.tasks.find_by(name: "Take out trash")
task.update!(frequency: "daily")  # Change schedule

# Deactivate task (soft delete)
task.update!(active: false)

# Reactivate task
task.update!(active: true)
```

## Production Deployment

### Database Setup

After deploying to production, initialize the database with real family data:

```bash
# Run migrations
bin/rails db:migrate

# Setup children and tasks (safe to run multiple times)
bin/rails setup:production
```

The production setup task will create:
- **Audrey**: 21 tasks (6 morning, 6 afternoon, 8 evening, 1 weekend)
- **Eddie**: 20 tasks (6 morning, 5 afternoon, 8 evening, 1 weekend)

Real task examples:
- Morning: wake up, eat breakfast, get dressed, brush teeth/hair, pack bag, get in car
- Afternoon: unpack, eat snack, clean table, complete math HW, self-study
- Evening: set table, take vitamins, clear table, pack lunch, complete reading HW, get PJs on, brush teeth, shower
- Weekend: run light load of laundry

### Deployment Notes

- The setup task uses `find_or_create_by` to prevent duplicate children
- Existing tasks are cleared on each run to ensure clean state
- All tasks are set to `active: true` and ready for immediate use
- Weekend tasks are scheduled for Saturday/Sunday afternoons

## Architecture

- **Database**: SQLite3 with 3 tables (children, tasks, task_completions)
- **Frontend**: Server-rendered ERB with Turbo for interactions
- **Styling**: Tailwind CSS with touch-optimized components
- **Deployment**: Configured for Kamal deployment

## Contributing

This is a personal family project, but feel free to fork and adapt for your own use!

## License

MIT