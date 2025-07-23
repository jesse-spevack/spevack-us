class TasksController < ApplicationController
  def daily
    # Hardcode first child for Phase 1
    @child = Child.first || Child.create!(name: "Test Child")
    @date = params[:date] ? Date.parse(params[:date]) : Date.current
    @tasks = @child.active_tasks.ordered
    @is_today = @date == Date.current
  end

  def toggle
    task = Task.find(params[:id])
    date = Date.parse(params[:date])

    completion = task.task_completions.find_by(completed_on: date)

    if completion
      completion.destroy!
    else
      task.task_completions.create!(completed_on: date)
    end

    redirect_to daily_tasks_path(date: date)
  end
end
