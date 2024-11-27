class EventParticipationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @event = Event.find(params[:event_id])
    @participation = @event.event_participations.build
    @participation.guests.build
  end

  def create
    @event = Event.find(params[:event_id])
    @participation = @event.event_participations.find_or_initialize_by(user: current_user)

    if @participation.update(participation_params)
      redirect_to @event, notice: 'Grazie per aver risposto.'
    else
      render :new
    end
  end

  private

  def participation_params
    params.require(:event_participation).permit(guests_attributes: [:id, :name, :surname, :_destroy])
  end
end