# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    if signed_in?
      @user = User.find_by(id: session[:user_id])
      @user_events = @user.events
      @upcoming_events = @user.attended_events.upcoming
      @past_events = @user.attended_events.past
    else
      redirect_to signin_path
    end
  end

  def going
    @event = Event.find(params[:id])
    @user = current_user
    @user.attended_events << @event
    @user.save
    redirect_to event_path(id: @event.id)
  end

  def not_going
    @event = Event.find(params[:id])
    @user = current_user
    @user.attended_events.delete(@event)
    redirect_to event_path(id: @event.id)
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
