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
# Quick task creation
eddie = Child.find_by(name: "Eddie")
eddie.add_daily_task("Make bed", :morning)
eddie.add_weekday_task("Take out trash", "1,3,5", :afternoon)  # MWF
eddie.add_weekend_task("Clean room", :afternoon)

# Or use the interactive task creator
rake chores:create
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

```ruby
# List all tasks
rake chores:list

# Create a task interactively
rake chores:create

# Direct task creation
Task.create!(
  child: Child.find_by(name: "Audrey"),
  name: "Feed cat",
  time_of_day: "morning",
  frequency: "daily"
)
```

## Architecture

- **Database**: SQLite3 with 3 tables (children, tasks, task_completions)
- **Frontend**: Server-rendered ERB with Turbo for interactions
- **Styling**: Tailwind CSS with touch-optimized components
- **Deployment**: Configured for Kamal deployment

## Contributing

This is a personal family project, but feel free to fork and adapt for your own use!

## License

MIT