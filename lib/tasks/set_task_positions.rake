namespace :tasks do
  desc "Set initial positions for all tasks"
  task set_positions: :environment do
    # Position mappings for logical task flow
    position_map = {
      "morning" => {
        "wake up" => 10,
        "get dressed" => 20,
        "make bed" => 30,
        "eat breakfast" => 40,
        "brush teeth/hair" => 50,
        "pack bag" => 60,
        "get in the car" => 70
      },
      "afternoon" => {
        "unpack" => 10,
        "eat snack" => 20,
        "clean table" => 30,
        "piano practice" => 40,
        "complete math hw" => 50,
        "self-study (typing, math facts)" => 60,
        "do homework" => 70,
        "clean room" => 80,
        "take out trash" => 90,
        "run light load of laundry" => 100
      },
      "evening" => {
        "set table" => 10,
        "set the table" => 10,  # Duplicate name variation
        "clear the table" => 20,
        "clean table" => 20,    # Duplicate name variation
        "take vitamins" => 30,
        "complete reading hw" => 40,
        "shower" => 50,
        "get pjs on" => 60,
        "brush teeth" => 70,
        "pack lunch" => 80
      }
    }

    total_updated = 0

    Child.find_each do |child|
      puts "Updating positions for #{child.name}..."

      position_map.each do |time_period, tasks|
        tasks.each do |task_name, position|
          # Case-insensitive match for task names
          updated = child.tasks
                        .where(time_of_day: time_period)
                        .where("LOWER(name) = ?", task_name.downcase)
                        .update_all(position: position)

          total_updated += updated
          puts "  #{time_period} - #{task_name}: #{updated > 0 ? 'Updated' : 'Not found'}" if updated == 0
        end
      end
    end

    puts "\nTotal tasks updated: #{total_updated}"

    # Show sample of new ordering
    puts "\nSample ordering for first child:"
    if child = Child.first
      %w[morning afternoon evening].each do |time_period|
        puts "\n#{time_period.capitalize}:"
        child.tasks.where(time_of_day: time_period).ordered.limit(5).each do |task|
          puts "  #{task.position}: #{task.name}"
        end
      end
    end
  end
end
