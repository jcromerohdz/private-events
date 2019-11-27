class ApplicationController < ActionController::Base
  include SessionsHelper
	# def sign_in(user)
 #    # remember_token = User.new_token
 #    # cookies.permanent[:remember_token] = remember_token
 #    # user.update_attribute(:remember_token, User.digest(remember_token))
 #    # @current_user = user
 #    session[:user_id] = user.id
 #  end

 #  # def current_user=(user)
 #  #   @current_user = user
 #  # end

 #  def current_user
 #    # remember_token = User.digest(cookies[:remember_token])
 #    # @current_user ||= User.find_by(remember_token: remember_token)
 #    if session[:user_id]
 #      @current_user ||= User.find_by(id: session[:user_id])
 #    end
 #  end

 #  def signed_in?
 #    !current_user.nil?
 #  end

 #  def sign_out
 #    # current_user.update_attribute(:remember_token,
 #    #                               User.digest(User.new_token))
 #    # cookies.delete(:remember_token)
 #    session.delete(:user_id) if logged_in?
 #    @current_user = nil
 #  end

 #  # def current_user?(user)
 #  #   user == current_user
 #  # end
end
