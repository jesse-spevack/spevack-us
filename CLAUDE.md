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
- `app/models/` - ActiveRecord models (only ApplicationRecord currently)
- `app/controllers/` - Controllers (only ApplicationController currently)  
- `app/views/` - ERB templates and layouts
- `app/javascript/` - Stimulus controllers and JavaScript
- `config/` - Rails configuration files
- `db/` - Database migrations and seeds
- `test/` - Test files (using Rails default testing)

### Current State
This appears to be a newly generated Rails application with no custom models, controllers, or routes defined yet. The application uses modern Rails conventions with Hotwire for interactivity and Tailwind for styling.

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
- **Console verification**: Use `rails console` to experiment and verify behavior
  ```ruby
  # Console for experimentation
  c = Child.create!(name: "Test")
  t = c.tasks.create!(name: "Test task", frequency: "daily")
  t.completed_on?(Date.current)  # Test methods work
  ```
- **Database constraints**: Match model validations with database constraints when critical
- **Implementation plans**: Always verify syntax against Rails 8.0.2 documentation

### Pre-Commit Checklist
Before committing Rails changes:
1. Run `rails db:migrate:status` to verify migration state
2. Run `rails test` for affected models/controllers
3. Run `bundle exec rubocop` to check code style
4. Check `db/schema.rb` reflects expected changes
5. Verify no deprecation warnings in server/console output