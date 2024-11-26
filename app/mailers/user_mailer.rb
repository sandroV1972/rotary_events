class UserMailer < ApplicationMailer
    def event_invitation(user, invitation)
      @user = user
      @invitation = invitation
      @event = invitation.event
      mail(to: @user.email, subject: "Sei invitato a #{@event.name}")
    end
  end
  