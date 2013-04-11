 class InviteObserver < ActiveRecord::Observer
  observe :invite

  def after_create(invite)
    if User.where(:email => invite.email).present?
      RegistrationMailer.group(invite).deliver
    else
      RegistrationMailer.invite(invite).deliver
    end
  end
end