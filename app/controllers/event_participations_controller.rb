class EventParticipationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @event = Event.find(params[:event_id])
    @participation = @event.event_participations.build
    @participation.guests.build
  end

  def create
    @event = Event.find(params[:event_id])
    @participation = @event.event_participations.build(participation_params)
    @participation.user = current_user

    if @participation.save
      redirect_to event_path(@event), notice: 'Partecipazione registrata con successo.'
    else
      render :new
    end
  end

  #def destroy_guest
  #  @guest = Guest.find(params[:id])
  #  @guest.destroy
  #  redirect_to event_path(@guest.event_participation.event), notice: 'Ospite cancellato con successo.'
  #end
  def destroy_guest
    @guest_event_participation = GuestEventParticipation.find(params[:id])
    @guest_event_participation.destroy
    redirect_to event_path(@guest_event_participation.event), notice: 'Ospite cancellato con successo.'
  end


  private

  def participation_params
    params.require(:event_participation).permit(:user_id, guests_attributes: [:id, :name, :surname, :_destroy])
  end
end