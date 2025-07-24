namespace :setup do
  desc "Setup production database with children and their tasks"
  task production: :environment do
    puts "Setting up production database..."

    # Create children
    puts "Creating children..."
    audrey = Child.find_or_create_by(name: "Audrey") do |child|
      child.theme = "default"
    end
    
    eddie = Child.find_or_create_by(name: "Eddie") do |child|
      child.theme = "default"
    end

    puts "Created children: #{Child.pluck(:name).join(', ')}"

    # Clear existing tasks to avoid duplicates
    puts "Clearing existing tasks..."
    Task.destroy_all

    # Audrey's tasks
    puts "Creating Audrey's tasks..."
    
    # Morning tasks (daily)
    audrey_morning_tasks = [
      "wake up",
      "eat breakfast", 
      "get dressed",
      "brush teeth/hair",
      "pack bag",
      "get in the car"
    ]
    
    audrey_morning_tasks.each do |task_name|
      audrey.tasks.create!(
        name: task_name,
        time_of_day: "morning",
        frequency: "daily"
      )
    end

    # Afternoon tasks (daily)
    audrey_afternoon_tasks = [
      "unpack",
      "eat snack",
      "clean table",
      "piano practice",
      "complete math HW",
      "self-study (typing, math facts)"
    ]
    
    audrey_afternoon_tasks.each do |task_name|
      audrey.tasks.create!(
        name: task_name,
        time_of_day: "afternoon", 
        frequency: "daily"
      )
    end

    # Evening tasks (daily)
    audrey_evening_tasks = [
      "set the table",
      "take vitamins",
      "clear the table", 
      "pack lunch",
      "complete reading HW",
      "get PJs on",
      "brush teeth",
      "shower"
    ]
    
    audrey_evening_tasks.each do |task_name|
      audrey.tasks.create!(
        name: task_name,
        time_of_day: "evening",
        frequency: "daily"
      )
    end

    # Weekend tasks
    audrey.tasks.create!(
      name: "run light load of laundry",
      time_of_day: "afternoon",
      frequency: "weekend"
    )

    # Eddie's tasks
    puts "Creating Eddie's tasks..."
    
    # Morning tasks (daily)
    eddie_morning_tasks = [
      "wake up",
      "eat breakfast",
      "get dressed", 
      "brush teeth/hair",
      "pack bag",
      "get in the car"
    ]
    
    eddie_morning_tasks.each do |task_name|
      eddie.tasks.create!(
        name: task_name,
        time_of_day: "morning",
        frequency: "daily"
      )
    end

    # Afternoon tasks (daily)
    eddie_afternoon_tasks = [
      "unpack",
      "eat snack", 
      "clean table",
      "complete math HW",
      "self-study (typing, math facts)"
    ]
    
    eddie_afternoon_tasks.each do |task_name|
      eddie.tasks.create!(
        name: task_name,
        time_of_day: "afternoon",
        frequency: "daily"  
      )
    end

    # Evening tasks (daily)
    eddie_evening_tasks = [
      "set the table",
      "take vitamins",
      "clear the table",
      "pack lunch", 
      "complete reading HW",
      "get PJs on",
      "brush teeth",
      "shower"
    ]
    
    eddie_evening_tasks.each do |task_name|
      eddie.tasks.create!(
        name: task_name,
        time_of_day: "evening",
        frequency: "daily"
      )
    end

    # Weekend tasks
    eddie.tasks.create!(
      name: "run light load of laundry", 
      time_of_day: "afternoon",
      frequency: "weekend"
    )

    # Summary
    puts "\n✓ Production database setup complete!"
    puts "Children created: #{Child.count}"
    puts "Total tasks created: #{Task.count}"
    puts "\nTasks by child:"
    Child.includes(:tasks).each do |child|
      puts "  #{child.name}: #{child.tasks.count} tasks"
      child.tasks.group(:time_of_day, :frequency).count.each do |(time, freq), count|
        puts "    - #{count} #{freq} #{time} tasks"
      end
    end
    
    puts "\nYou can now run the application!"
  end
end