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

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_dashboard_path, notice: 'Utente creato con successo.'
      else
        render :new
      end
    end

    # GET /admin/users/:id/edit
    #
    # Show the edit form to edit a user.
    def edit
      @user = User.find(params[:id])
    end

# Updates an existing user with the provided parameters.
# If the update is successful, redirects to the admin users index with a success notice.
# If the update fails, re-renders the edit form.
    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        redirect_to admin_dashboard_path, notice: 'Utente aggiornato con successo.'
      else
        render :edit
      end
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy
      redirect_to admin_dashboard_path, notice: 'Utente eliminato con successo.'
    end

    private

    def verify_admin
      redirect_to root_path, alert: 'Non sei autorizzato a questa azione.' unless current_user.admin?
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :role_id, :password, :password_confirmation)
    end
  end
end
