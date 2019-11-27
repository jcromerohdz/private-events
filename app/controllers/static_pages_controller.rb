class StaticPagesController < ApplicationController
  def home
    if current_user
      @user = current_user
      @upcoming_events = @user.attended_events.upcoming
    end
  end

  def about
  end
end
