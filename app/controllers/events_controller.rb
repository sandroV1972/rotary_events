class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin, only: [:new, :create, :edit, :update, :destroy, :send_invites]

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
      redirect_to event_path(@event), notice: 'Evento creato con successo.'
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
      redirect_to event_path(@event), notice: 'Evento aggiornato con successo.'
    else
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path, notice: 'Evento eliminato con successo.'
  end

  def send_invites
    @event = Event.find(params[:id])
    user_ids = params[:invitation][:user_ids].reject(&:blank?) || []
    users = User.where(id: user_ids)
    Rails.logger.info "Invio inviti a #{users.count} utenti"

    users.each do |user|
      # Crea l'invito con lo stato pending e registra la data e l'ora dell'invio
      Rails.logger.info "Invio invito...creato"

      invitation = Invitation.create(event: @event, user: user, sent_at: Time.current, status: :pending)
      if invitation.persisted?
        Rails.logger.info "Invito creato per l'utente #{user.email}"
      else
        Rails.logger.error "Errore nella creazione dell'invito per l'utente #{user.email}: #{invitation.errors.full_messages.join(", ")}"
      end

      # Genera l'URL di invito
      invitation_url = confirm_invitation_url(invitation.token, host: 'localhost', port: 3000)

      # Invia l'email di invito (assicurati di avere un mailer configurato)
      begin
        UserMailer.event_invitation(user, invitation, invitation_url).deliver_now
        Rails.logger.info "Email inviata a #{user.email}"
      rescue => e
        Rails.logger.error "Errore nell'invio dell'email a #{user.email}: #{e.message}"
      end
    end

    redirect_to event_path(@event), notice: 'Inviti inviati con successo.'
  end

  def cancel_invite
    @event = Event.find(params[:event_id])
    @invitation = @event.invitations.find(params[:invitation_id])
    @invitation.destroy
    redirect_to event_path(@event), notice: 'Invito annullato con successo.'
  end

  private
  def event_params
    params.require(:event).permit(:name, :description, :date, :time, :location, :event_type_id)
  end

  def verify_admin
    redirect_to(root_path, alert: 'Non sei autorizzato a questa azione.') unless current_user.admin?
  end
end