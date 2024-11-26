module Admin
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :verify_admin

    def   index
      @events = Event.all
      @users = User.all
      @event_types = EventType.all
    end

    private

    def verify_admin
      redirect_to root_path, alert: 'Non sei autorizzato a aprore questa pagina.' unless current_user.admin?
    end
  end
end
