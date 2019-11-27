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
		@user = User.find(params[:id])
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

	private

    def user_params
      params.require(:user).permit(:name, :email)
    end

end
