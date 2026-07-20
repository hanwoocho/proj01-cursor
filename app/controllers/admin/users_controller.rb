class Admin::UsersController < ApplicationController
  before_action :require_login
  before_action :require_admin

  def index
    @users = User.order(:username)
  end

  def destroy
    @user = User.find(params[:id])

    if @user == current_user
      redirect_to admin_users_path, alert: "자기 자신은 삭제할 수 없습니다."
    elsif @user.admin? && User.where(admin: true).count <= 1
      redirect_to admin_users_path, alert: "마지막 관리자는 삭제할 수 없습니다."
    else
      username = @user.username
      @user.destroy
      redirect_to admin_users_path, notice: "#{username} 회원이 삭제되었습니다."
    end
  end
end
