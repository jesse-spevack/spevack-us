class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_child, :theme_class, :user_timezone

  private

  def set_date
    # Date parameters are expected to be in YYYY-MM-DD format representing the user's local date
    # We parse them as-is since they represent calendar dates, not specific moments in time
    if params[:date].present?
      begin
        @date = Date.parse(params[:date])
      rescue ArgumentError
        # Fall back to current date if parsing fails
        @date = Date.current
      end
    else
      # For "today", we use the server's current date
      # The client-side JavaScript will handle displaying this correctly in local timezone
      @date = Date.current
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

  def user_timezone
    # This will be set by JavaScript and sent via a header or cookie
    # For now, we'll use UTC as the default
    request.headers["X-User-Timezone"] || cookies[:user_timezone] || "UTC"
  end
end
