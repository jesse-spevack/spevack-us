class TasksController < ApplicationController
  include TimezoneHelper

  before_action :require_child
  before_action :set_date
  before_action :set_today

  def index
    @child = current_child
    @tasks = @child.active_tasks
  end

  private

  def set_today
    @today = @date == Time.zone.today
  end
end
