module SessionsHelper
def sign_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    session.delete(:user_id) if signed_in?
    @current_user = nil
  end
end
