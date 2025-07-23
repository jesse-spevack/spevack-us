class TaskCompletion < ApplicationRecord
  belongs_to :task

  validates :completed_on, presence: true
  validates :task_id, uniqueness: { scope: :completed_on }
end
