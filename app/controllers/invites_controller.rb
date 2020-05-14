class InvitesController < ApplicationController
  def new
  end

  def create
    response = GithubResponse.new
    invitee_info = response.invitee_info(params[:handle], current_user.token)
    inviter_name = response.user_name(current_user.token)
    
    if invitee_info[:email]
      email_info = {user: inviter_name,
                    invitee: invitee_info[:login]
                  }
      FriendInviterMailer.invite(email_info, invitee_info[:email]).deliver_now
      flash[:success] = "Successfully sent invite!"
      redirect_to dashboard_path
    else
      flash[:error] = "The GitHub user you selected doesn't have an email address associated with their account."
      redirect_to '/invite'
    end
  end
end