class RegistrationMailer < ActionMailer::Base
  default :from => "chanson300@gmail.com"

  def invite(invite)
    headers["Reply-To"] = "Corey Hanson <chanson300@gmail.com>"
    @user = User.find(invite.user_id)
    @group = Group.find(invite.group_id)

    mail(:to => invite.email, :subject => "Join your friend's group on TskIt")
  end

  def group(invite)
    headers["Reply-To"] = "Corey Hanson <chanson300@gmail.com>"
    @user = User.find(invite.user_id)
    @group = Group.find(invite.group_id)
    @friend = User.where(:email => invite.email).first

    mail(:to => invite.email, :subject => "Join your friend's group at TskIt")
  end
end