class Child < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_many :active_tasks, -> { where(active: true).ordered }, class_name: "Task"
  has_many :task_completions, through: :tasks

  validates :name, presence: true, uniqueness: true

  def add_daily_task(name, time_of_day = :afternoon)
    tasks.create!(name: name, time_of_day: time_of_day, frequency: "daily")
  end

  def add_weekend_task(name, time_of_day = :afternoon)
    tasks.create!(name: name, time_of_day: time_of_day, frequency: "weekend")
  end

  def add_weekday_task(name, days, time_of_day = :afternoon)
    tasks.create!(
      name: name,
      time_of_day: time_of_day,
      frequency: "specific_days",
      specific_days: days.is_a?(Array) ? days.join(",") : days
    )
  end
end
