class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_user_timezone
  helper_method :current_child, :theme_class

  private

  def set_user_timezone
    tz = cookies[:timezone]
    Time.zone = tz.present? && ActiveSupport::TimeZone[tz] ? tz : "UTC"
  end

  def set_date
    if params[:date].present?
      begin
        # Parse the date string in the user's timezone
        @date = Time.zone.parse(params[:date]).to_date
      rescue ArgumentError
        # Fall back to today if parsing fails
        @date = Time.zone.today
      end
    else
      # Get "today" in the user's timezone
      @date = Time.zone.today
    end
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
