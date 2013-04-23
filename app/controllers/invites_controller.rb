class InvitesController < ApplicationController
  def create
    email = params[:invite][:email].try(:downcase)
    @invite = Invite.create(params_invite.merge(:email => email))

    if @invite.save
      redirect_to root_path, :notice => "Invite successfully created."
    else
      redirect_to root_path, :flash => { :error => @invite.errors.join(', ') }
    end
  end

  def new
    @invite = Invite.new
  end

  def destroy
    Invite.find(params[:id]).destroy
  end

  private

  def params_invite
    params.require(:invite).permit(
      :email,
      :user_id,
      :group_id,
      :invites_attributes
    )
  end
end