class StaticPagesController < ApplicationController
  def home
    if current_user
      @user = current_user
      @user_events = @user.events
      @upcoming_events = @user.attended_events.upcoming
      @past_events = @user.attended_events.past
    end
  end

  def about
  end
end
