class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    if params[:user].present? && params[:group].present?
      if params[:group][:group_id].present? && params[:user][:id]
        user = User.find(params[:user][:id])
        group = Group.find(params[:group][:group_id])
        unless user.groups.where(:id => group.id).any?
          user.groups << group
        end
        redirect_to group_path(group), :notice => 'Welcome to the group!'
      end
    else
      authorize! :index, @user, :message => 'Not authorized as an administrator.'
      @users = User.all
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    # authorize! :update, @user, :message => 'Not authorized as an administrator.'
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])#, :as => :admin)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
    user = User.find(params[:id])
    unless user == current_user
      user.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end

end