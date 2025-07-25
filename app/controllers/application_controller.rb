class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_child, :theme_class

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

  def theme_class
    if current_child
      case current_child.theme
      when "neo-brutalism"
        "theme-neo-brutalism"
      when "candy"
        "theme-retro-gurl"
      else
        "theme-default"
      end
    else
      "theme-default"
    end
  end
end
