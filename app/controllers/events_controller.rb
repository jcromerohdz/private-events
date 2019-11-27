class EventsController < ApplicationController
  before_action :log_in_user, only: [:create]

  def new
    if signed_in?
      @event = current_user.events.build
    else
      flash[:danger] = "Kindly log in to create an event"
      redirect_to signin_path
    end
  end

  def create
    @event = current_user.events.build(event_params)
    if @event.save
      redirect_to event_path(id: @event.id)
    else
      render 'new'
    end
  end

  def index
    @events = Event.all
    @past_events = @events.past
    @upcoming_events = @events.upcoming
  end

  def show
    @user = current_user
    @event = Event.find(params[:id])
    @is_upcoming = Event.upcoming.include?(@event)
  end

  def signed_in?
    !current_user.nil?
  end

  private

  def event_params
    params.require(:event)
          .permit(:name, :description, :location, :time)
  end

  def log_in_user
    unless signed_in?
      flash[:danger] = "Kindly log in to create an event"
      redirect_to login_path
    end
  end
end