class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  helper_method :current_user, :logged_in?, :admin?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def admin?
    current_user&.admin?
  end

  def require_login
    return if logged_in?

    redirect_to login_path, alert: "로그인이 필요합니다."
  end

  def require_admin
    return if admin?

    redirect_to rooms_path, alert: "관리자 권한이 필요합니다."
  end
end
