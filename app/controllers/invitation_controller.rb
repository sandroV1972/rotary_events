class InvitationsController < ApplicationController
    def confirm
      @invitation = Invitation.find_by(token: params[:token])
      if @invitation
        @invitation.update(status: "accepted")
        redirect_to new_event_event_participation_path(@invitation.event), notice: 'You have accepted the invitation. Now you can register your participation and add guests.'
      else
        redirect_to root_path, alert: 'Invalid invitation.'
      end
    end
  end