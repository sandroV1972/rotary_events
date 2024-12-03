class GuestsController < ApplicationController
    def destroy
      @invitation = Invitation.find_by(token: params[:invitation_token])
      @guest = @invitation.guests.find(params[:id])
      @guest.destroy
      redirect_to edit_invitation_path(@invitation.token), notice: 'Ospite rimosso con successo.'
    end
  end