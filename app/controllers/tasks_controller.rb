class TasksController < ApplicationController
  before_action :require_child
  before_action :set_date
  before_action :set_is_today

  def index
    @child = current_child
    @tasks = @child.active_tasks
  end

  private

  def set_is_today
    @is_today = @date == Date.current
  end
end
