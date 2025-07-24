class SessionsController < ApplicationController
  def new
    # If child is already selected, go directly to tasks
    redirect_to root_path if current_child

    @children = Child.all.order(:name)
  end

  def create
    child = Child.find(params[:id])
    session[:child_id] = child.id
    redirect_to root_path
  end

  def destroy
    session[:child_id] = nil
    redirect_to new_session_path
  end
end
