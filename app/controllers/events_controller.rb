class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin, only: [:new, :create, :edit, :update, :destroy]

  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to @event, notice: 'Evento creato con successo.'
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
      redirect_to @event, notice: 'Evento aggiornato con successo.'
    else
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path, notice: 'Evento eliminato con successo.'
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :date, :location)
  end

  def verify_admin
    redirect_to(root_path, alert: 'Non sei autorizzato a questa azione.') unless current_user.admin?
  end
end