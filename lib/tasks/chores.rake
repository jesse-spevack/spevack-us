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
      [ "weekend", nil ]
    when "3"
      puts "Enter days (0=Sun, 1=Mon, etc.), comma-separated: "
      days = STDIN.gets.chomp
      [ "specific_days", days ]
    else
      [ "daily", nil ]
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
