namespace :demo do
  desc "Create a demo child with realistic tasks"
  task create_child: :environment do
    demo = Child.create!(name: "Demo")
    puts "Created child: #{demo.name} (ID: #{demo.id})"

    # Morning tasks
    demo.add_daily_task("Make bed", :morning)
    demo.add_daily_task("Brush teeth", :morning)
    demo.add_daily_task("Get dressed", :morning)
    demo.add_daily_task("Feed pets", :morning)

    # Afternoon tasks
    demo.add_daily_task("Tidy room", :afternoon)
    demo.add_daily_task("Put dishes away", :afternoon)
    demo.add_daily_task("Homework time", :afternoon)
    demo.add_weekday_task("Practice piano", [ "monday", "wednesday", "friday" ], :afternoon)

    # Evening tasks
    demo.add_daily_task("Pack backpack", :evening)
    demo.add_daily_task("Lay out clothes", :evening)
    demo.add_weekday_task("Take out trash", [ "tuesday", "friday" ], :evening)

    # Weekend tasks
    demo.add_weekend_task("Help with laundry", :afternoon)
    demo.add_weekend_task("Clean bedroom", :morning)
    demo.add_weekend_task("Organize desk", :afternoon)

    # Specific day tasks
    demo.add_weekday_task("Library books", [ "monday" ], :afternoon)
    demo.add_weekday_task("Soccer gear", [ "wednesday" ], :evening)

    puts "Added realistic tasks for #{demo.name}"
    puts "Total tasks created: #{demo.tasks.count}"
  end
end
