class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def set_date
    @date = params[:date] ? Date.parse(params[:date]) : Date.current
  end
end
