module Admin
  class EventsController < ApplicationController
    before_action :authenticate_user!
    before_action :verify_admin

    def show
      @event = Event.find(params[:id])
      @users = User.all
    end

    #def send_invites
    #  @event = Event.find(params[:id])
    #  # Logica per inviare gli inviti
    #  redirect_to admin_event_path(@event), notice: 'Inviti inviati con successo.'
    #end
    def send_invites
      @event = Event.find(params[:id])
      user_ids = params[:invitation][:user_ids]
      user_ids.each do |user_id|
        user = User.find(user_id)
        invitation = @event.invitations.create(user: user, event: @event, sent_at: Time.current)
        # Logica per inviare l'email di invito
      end
      redirect_to admin_event_path(@event), notice: 'Inviti inviati con successo.'
    end

    def cancel_invite
      @event = Event.find(params[:id])
      @invitation = @event.invitations.find(params[:invitation_id])
      @invitation.destroy
      redirect_to admin_event_path(@event), notice: 'Invito cancellato con successo.'
    end
    def destroy
      @event = Event.find(params[:id])
      @event.destroy
      redirect_to events_path, notice: 'Evento eliminato con successo.'
    end
    
    def destroy_guest
      Rails.logger.info "Evento ID: #{params[:id]}, Guest ID: #{params[:guest_id]}"

      @event = Event.find(params[:id])
      @guest = Guest.find(params[:guest_id])
      @guest.destroy
      redirect_to admin_event_path(params[:id]), notice: 'Ospite cancellato con successo.'
    end


    private

    def verify_admin
      redirect_to(root_path, alert: 'Non sei autorizzato a questa azione.') unless current_user.admin?
    end
  end
end