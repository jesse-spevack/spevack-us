class Task < ApplicationRecord
  belongs_to :child
  has_many :task_completions, dependent: :destroy

  validates :name, presence: true
  validates :frequency, inclusion: { in: %w[daily weekend specific_days] }

  enum :time_of_day, { morning: 0, afternoon: 1, evening: 2 }

  scope :ordered, -> { order(:time_of_day, :name) }

  def due_on?(date)
    case frequency
    when "daily"
      true
    when "weekend"
      [ 0, 6 ].include?(date.wday)  # Sunday = 0, Saturday = 6
    when "specific_days"
      return false if specific_days.blank?
      specific_days.split(",").map(&:to_i).include?(date.wday)
    end
  end

  def completed_on?(date)
    task_completions.exists?(completed_on: date)
  end
end
