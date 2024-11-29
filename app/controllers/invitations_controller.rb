class InvitationsController < ApplicationController
  before_action :authenticate_user!, except: [:confirm]

  def create
    @event = Event.find(params[:event_id])
    @invitation = @event.invitations.find_or_initialize_by(user: current_user)

    if @invitation.new_record?
      @invitation.sent_at = Time.current
    end

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

  def destroy
    @invitation = Invitation.find(params[:id])
    @event = @invitation.event
    @invitation.destroy
    redirect_to @event, notice: 'Invito annullato con successo.'
  end
end

module Admin
  class EventsController < ApplicationController
    before_action :authenticate_user!
    before_action :verify_admin

    def index
      @events = Event.all
    end

    def show
      @event = Event.find(params[:id])
      @users = User.all
    end

    def new
      @event = Event.new
    end

    def create
      @event = Event.new(event_params)
      if @event.save
        redirect_to admin_event_path(@event), notice: 'Evento creato con successo.'
      else
        render :new
      end
    end

    def edit
      @event = Event.find(params[:id])
    end

    def update
      @event = Event.find(params[:id])
      if @event.update(event_params)
        redirect_to admin_event_path(@event), notice: 'Evento aggiornato con successo.'
      else
        render :edit
      end
    end

    def destroy
      @event = Event.find(params[:id])
      @event.destroy
      redirect_to admin_events_path, notice: 'Evento eliminato con successo.'
    end

    def send_invites
      @event = Event.find(params[:id])
      user_ids = params[:user_ids] || []
      users = User.where(id: user_ids)

      users.each do |user|
        # Logica per inviare l'invito all'utente
        Invitation.create(event: @event, user: user, sent_at: Time.current)
        # Inviare email di invito (assicurati di avere un mailer configurato)
        UserMailer.event_invitation(user, @event).deliver_now
      end

      redirect_to admin_event_path(@event), notice: 'Inviti inviati con successo.'
    end

    private

    def event_params
      params.require(:event).permit(:name, :description, :date, :location, :event_type_id)
    end

    def verify_admin
      redirect_to(root_path, alert: 'Non sei autorizzato a questa azione.') unless current_user.admin?
    end
  end
end