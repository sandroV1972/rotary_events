module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :verify_admin

    def index
      @users = User.all
    end

    def show
      @user = User.find(params[:id])
    end

    def edit
      @user = User.find(params[:id])
      @roles = Role.all
    end

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        redirect_to admin_user_path(@user), notice: 'Utente aggiornato con successo.'
      else
        @roles = Role.all
        render :edit
      end
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy
      redirect_to admin_users_path, notice: 'Utente eliminato con successo.'
    end

    private

    def verify_admin
      redirect_to root_path, alert: 'Non sei autorizzato a questa azione.' unless current_user.admin?
    end

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :role)
    end
  end
end
