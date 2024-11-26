class EventTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin

  def index
    @event_types = EventType.all
  end

  def new
    @event_type = EventType.new
  end

  def create
    @event_type = EventType.new(event_type_params)
    if @event_type.save
      redirect_to admin_dashboard_path, notice: 'Tipologia di evento creata con successo.'
    else
      render :new
    end
  end

  def edit
    @event_type = EventType.find(params[:id])
  end

  def update
    @event_type = EventType.find(params[:id])
    if @event_type.update(event_type_params)
      redirect_to admin_dashboard_path, notice: 'Tipologia di evento aggiornata con successo.'
    else
      render :edit
    end
  end

  def destroy
    @event_type = EventType.find(params[:id])
    @event_type.destroy
    respond_to do |format|
        format.html { redirect_to admin_dashboard_path, notice: 'Tipologia di evento eliminata con successo.' }
        format.js   { render inline: "location.reload();" }
    end
  end

  private

  def event_type_params
    params.require(:event_type).permit(:name)
  end

  def verify_admin
    redirect_to root_path, alert: 'Non sei autorizzato a questa azione.' unless current_user.admin?
  end
end
