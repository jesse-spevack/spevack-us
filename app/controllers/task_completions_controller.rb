class TaskCompletionsController < ApplicationController
  before_action :require_child
  before_action :set_task
  before_action :set_date

  def create
    completion = @task.task_completion_for_day(@date)

    unless completion
      @task.task_completions.create!(completed_on: @date)
    end

    respond_to do |format|
      format.turbo_stream { render_tasks_frame }
      format.html { redirect_to tasks_path(date: @date) }
    end
  end

  def destroy
    completion = @task.task_completion_for_day(@date)
    completion&.destroy!

    respond_to do |format|
      format.turbo_stream { render_tasks_frame }
      format.html { redirect_to tasks_path(date: @date) }
    end
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end

  def render_tasks_frame
    # Set up variables needed for the tasks view
    @child = current_child
    @tasks = @child.active_tasks
    @is_today = @date == Date.current

    render turbo_stream: turbo_stream.replace("tasks", partial: "tasks/tasks_frame")
  end
end
