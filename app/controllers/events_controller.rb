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
    @users = User.all
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to @event, notice: 'Evento creato con successo.'
    else
      @users = User.all
      render :new
    end
  end

  # Other actions (edit, update, show, destroy)...
  def edit
    @event = Event.find(params[:id])
    @users = User.all
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to @event, notice: 'L\'evento è stato aggiornato con successo.'
    else
      @users = User.all
      render :edit
    end
  end
  
  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path, notice: 'Evento eliminato con successo.'
  end


  private

  def verify_admin
    redirect_to root_path, alert: 'Non sei autorizzato a questa azione.' unless current_user.admin?
  end

  def event_params
    params.require(:event).permit(:name, :description, :date, :time, :location, :event_type_id, invited_user_ids: [])
  end
end