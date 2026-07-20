class SessionsController < ApplicationController
  def new
    redirect_to rooms_path if logged_in?
  end

  def create
    user = User.find_by("LOWER(username) = ?", params[:username].to_s.downcase)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to rooms_path, notice: "환영합니다, #{user.username}님!"
    else
      flash.now[:alert] = "아이디 또는 비밀번호가 올바르지 않습니다."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to login_path, notice: "로그아웃되었습니다."
  end
end
