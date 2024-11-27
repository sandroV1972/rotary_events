require 'test_helper'

class InvitationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @invitation = invitations(:one)
  end

  test "should get confirm" do
    get confirm_invitation_url(@invitation.token)
    assert_response :success
  end

  test "should post respond" do
    post respond_invitation_url(@invitation), params: { commit: 'Accetta' }
    assert_redirected_to new_event_event_participation_path(@invitation.event)
  end
end