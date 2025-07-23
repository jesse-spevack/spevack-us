class Child < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_many :active_tasks, -> { where(active: true).ordered }, class_name: "Task"
  has_many :task_completions, through: :tasks

  validates :name, presence: true, uniqueness: true
end
