class TasksController < ApplicationController
  before_action :set_child
  before_action :set_date
  before_action :set_is_today

  def index
    @tasks = @child.active_tasks
  end

  private

  def set_child
    @child = Child.first
  end

  def set_is_today
    @is_today = @date == Date.current
  end
end
