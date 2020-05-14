class FriendInviterMailer < ApplicationMailer
   def invite(info, friend_email)
    @user = info[:user]
    @invitee = info[:invitee]
    mail(to: friend_email, subject: "#{@user} is sending you an invite")
  end
end
