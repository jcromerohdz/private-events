class SessionsController < ApplicationController
	def new
	end
	
	def create 
		user = User.find_by(email: params[:session][:email])
		if user
			sign_in user
			redirect_to user
		else 
			flash.now[:danger] = 'Invalid email'
			render 'new'
		end 
	end 
	
	def destroy
		sign_out
		if signed_in?
			redirect_to root_path
		end
	end

end