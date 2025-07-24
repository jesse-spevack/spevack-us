class ChildrenController < ApplicationController
  def index
    # If child is already selected, go directly to tasks
    redirect_to tasks_path if current_child

    @children = Child.all.order(:name)
  end

  def select
    child = Child.find(params[:id])
    cookies[:child_id] = child.id
    redirect_to tasks_path
  end
end
