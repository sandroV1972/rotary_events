class InvitationsController < ApplicationController
  before_action :authenticate_user!, except: [:confirm]

  def create
    @event = Event.find(params[:event_id])
    @invitation = @event.invitations.build(user: current_user)

    if @invitation.save
      invitation_url = confirm_invitation_url(@invitation.token, host: 'localhost', port: 3000)
      UserMailer.event_invitation(current_user, @invitation, invitation_url).deliver_now
      redirect_to @event, notice: 'Invito inviato con successo.'
    else
      redirect_to @event, alert: 'Errore nell\'invio dell\'invito.'
    end
  end

  def update
    @invitation = Invitation.find(params[:id])
    if @invitation.update(status: params[:status])
      redirect_to @invitation.event, notice: 'Stato dell\'invito aggiornato con successo.'
    else
      redirect_to @invitation.event, alert: 'Errore nell\'aggiornamento dello stato dell\'invito.'
    end
  end

  def confirm
    @invitation = Invitation.find_by(token: params[:token])
    if @invitation
      @invitation.update(status: "accepted")
      redirect_to new_event_event_participation_path(@invitation.event), notice: 'Hai accettato l\'invito. Ora puoi registrare la tua partecipazione e aggiungere ospiti.'
    else
      redirect_to root_path, alert: 'Invito non valido.'
    end
  end
end