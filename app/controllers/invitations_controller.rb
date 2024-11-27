class InvitationsController < ApplicationController
  before_action :authenticate_user!, except: [:confirm]

  def create
    @event = Event.find(params[:event_id])
    @invitation = @event.invitations.build(user: current_user)

    if @invitation.save
      Rails.logger.info "Invito salvato con successo per l'evento #{@event.name}"
      invitation_url = confirm_invitation_url(@invitation.token, host: 'localhost', port: 3000)
      Rails.logger.info "URL di invito generato: #{invitation_url}"
      UserMailer.event_invitation(current_user, @invitation, invitation_url).deliver_now
      redirect_to @event, notice: 'Invito inviato con successo.'
    else
      Rails.logger.error "Errore nel salvataggio dell'invito: #{@invitation.errors.full_messages.join(", ")}"
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
      @event = @invitation.event
      render :confirm
    else
      redirect_to root_path, alert: 'Invito non valido.'
    end
  end

  def respond
    @invitation = Invitation.find(params[:id])
    if params[:commit] == 'Accetta'
      @invitation.update(status: 'accepted')
      redirect_to new_event_event_participation_path(@invitation.event), notice: 'Hai accettato l\'invito. Ora puoi registrare la tua partecipazione e aggiungere ospiti.'
    elsif params[:commit] == 'Rifiuta'
      @invitation.update(status: 'declined')
      redirect_to root_path, notice: 'Hai rifiutato l\'invito.'
    else
      redirect_to root_path, alert: 'Azione non valida.'
    end
  end
end