class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def set_date
    @date = params[:date] ? Date.parse(params[:date]) : Date.current
  end

  def current_child
    @current_child ||= Child.find_by(id: session[:child_id])
  end

  def require_child
    redirect_to new_session_path unless current_child
  end
end
