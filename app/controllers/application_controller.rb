# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user, :signed_in?

  def sign_in(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    session.delete(:user_id) if signed_in?
    @current_user = nil
  end
end
