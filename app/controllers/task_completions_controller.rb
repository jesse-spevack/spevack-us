class TaskCompletionsController < ApplicationController
  before_action :set_task
  before_action :set_date

  def create
    completion = @task.task_completion_for_day(@date)

    unless completion
      @task.task_completions.create!(completed_on: @date)
    end

    redirect_to tasks_path(date: @date)
  end

  def destroy
    completion = @task.task_completion_for_day(@date)
    completion&.destroy!

    redirect_to tasks_path(date: @date)
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end
end
