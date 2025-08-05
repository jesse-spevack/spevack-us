class Task < ApplicationRecord
  SUNDAY = 0
  SATURDAY = 6
  WEEKEND = [ SATURDAY, SUNDAY ].freeze

  belongs_to :child
  has_many :task_completions, dependent: :destroy

  validates :name, presence: true
  validates :frequency, inclusion: { in: %w[daily weekend specific_days] }

  enum :time_of_day, { morning: 0, afternoon: 1, evening: 2 }

  scope :ordered, -> { order(:time_of_day, :position, :name) }

  def due_on?(date)
    case frequency
    when "daily"
      true
    when "weekend"
      WEEKEND.include?(date.wday)
    when "specific_days"
      return false if specific_days.blank?

      specific_days.split(",").map(&:to_i).include?(date.wday)
    end
  end

  def completed_on?(date)
    task_completions.exists?(completed_on: date)
  end

  def task_completion_for_day(date)
    task_completions.find_by(completed_on: date)
  end

  def dates_for_week(week_start)
    week_end = week_start.end_of_week
    (week_start..week_end).select { |date| due_on?(date) }
  end
end
