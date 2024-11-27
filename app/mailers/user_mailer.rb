class UserMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  def event_invitation(user, invitation, invitation_url)
    Rails.logger.info "Invio email di invito a #{user.email} per l'evento #{invitation.event.name}"
    @user = user
    @invitation = invitation
    @event = invitation.event
    @url = invitation_url
    mail(to: @user.email, subject: "Sei invitato a #{@event.name}")
  end
end