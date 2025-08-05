class TasksController < ApplicationController
  include TimezoneHelper

  before_action :require_child
  before_action :set_date
  before_action :set_is_today

  def index
    @child = current_child
    @tasks = @child.active_tasks
  end

  private

  def set_is_today
    # The client-side JavaScript will determine the actual "today" in user's timezone
    # This is used for server-side logic and as a fallback
    @is_today = @date == Date.current
  end
end
