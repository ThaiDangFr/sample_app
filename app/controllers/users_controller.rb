class UsersController < ApplicationController

  def show
  	@user = User.find(params[:id])
		@titre = @user.nom
  end

  def new
		@user = User.new
		@titre = "Inscription"
  end

  def create
		@user = User.new(user_params)
			if @user.save
				sign_in @user
				flash[:success] = "Bienvenue dans l'application exemple !"
				redirect_to @user
			else
				@titre = "Inscription"
				render 'new'
			end
  end

	def edit
		@user = User.find(params[:id])
		@titre = "Edition profil"
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(user_params)
			flash[:success] = "Profil actualisé."
			redirect_to @user
		else
			@titre = "Edition profil"
			render 'edit'
		end
	end

	private

  def user_params
    params.require(:user).permit(:nom, :email, :password, :salt, :encrypted_password)
  end
end
