class EventParticipationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @event = Event.find(params[:event_id])
    @participation = @event.event_participations.build
  end

  def create
    @event = Event.find(params[:event_id])
    @participation = @event.event_participations.build(participation_params)
    @participation.user = current_user

    if @participation.save
      redirect_to @event, notice: 'Partecipazione creata con successo.'
    else
      render :new
    end
  end

  def destroy_guest
    @guest = Guest.find(params[:id])
    @guest.destroy
    redirect_to event_path(params[:event_id]), notice: 'Ospite cancellato con successo.'
  end

  private

  def participation_params
    params.require(:event_participation).permit(:user_id, guests_attributes: [:id, :name, :surname, :_destroy])
  end
end