# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def home
    return unless current_user

    @user = current_user
    @user_events = @user.events
    @upcoming_events = @user.attended_events.upcoming
    @past_events = @user.attended_events.past
  end

  def about; end
end
