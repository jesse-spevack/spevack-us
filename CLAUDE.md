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