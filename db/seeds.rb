# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create children
eddie = Child.find_or_create_by!(name: "Eddie") { |c| c.theme = "neo-brutalism" }
audrey = Child.find_or_create_by!(name: "Audrey") { |c| c.theme = "candy" }

# Eddie's tasks
eddie.tasks.find_or_create_by!(name: "Make bed") { |t| t.time_of_day = "morning"; t.frequency = "daily" }
eddie.tasks.find_or_create_by!(name: "Brush teeth") { |t| t.time_of_day = "morning"; t.frequency = "daily" }
eddie.tasks.find_or_create_by!(name: "Take out trash") do |t|
  t.time_of_day = "afternoon"
  t.frequency = "specific_days"
  t.specific_days = "1,3,5"
end
eddie.tasks.find_or_create_by!(name: "Do homework") do |t|
  t.time_of_day = "afternoon"
  t.frequency = "specific_days"
  t.specific_days = "1,2,3,4,5"
end
eddie.tasks.find_or_create_by!(name: "Clean room") { |t| t.time_of_day = "afternoon"; t.frequency = "weekend" }
eddie.tasks.find_or_create_by!(name: "Set table") { |t| t.time_of_day = "evening"; t.frequency = "daily" }

# Audrey's tasks
audrey.tasks.find_or_create_by!(name: "Make bed") { |t| t.time_of_day = "morning"; t.frequency = "daily" }
audrey.tasks.find_or_create_by!(name: "Feed cat") { |t| t.time_of_day = "morning"; t.frequency = "daily" }
audrey.tasks.find_or_create_by!(name: "Practice piano") do |t|
  t.time_of_day = "afternoon"
  t.frequency = "specific_days"
  t.specific_days = "1,2,3,4,5"
end
audrey.tasks.find_or_create_by!(name: "Clear dishes") { |t| t.time_of_day = "evening"; t.frequency = "daily" }
