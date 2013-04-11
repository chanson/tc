class GroupsController < ApplicationController
  before_filter :find_group, :only => [:edit, :update, :show, :destroy]

  def new
    @group = Group.new
  end

  def create
    @group = current_user.groups.create(params_group)

    if @group.save
      redirect_to group_path(@group), :notice => 'Group Created'
    else
      flash.now[:error] = @group.errors.full_messages.join(', ')
      render :new
    end
  end

  def update
    if @group.update_attributes(params_group)
      redirect_to group_path(@group), :notice => 'Group Successfully Updated'
    else
      flash.now[:error] = @group.errors.full_messages.join(', ')
      render :edit
    end
  end

  def show
    @owner = User.find(@group.owner_id)
  end

  def destroy
    @group.destroy
    redirect_to root_path
  end

  def edit
    @owner = @group.owner_id
    @group_users = @group.users
  end


  private

  def find_group
    @group = Group.find(params[:id])
  end

  def params_group
    params.require(:group).permit(
      :name,
      :owner_id,
      :logo_image,
      :retained_logo_image,
      :remove_logo_image,
      :invites_attributes => [:email, :user_id, :_destroy,]
    )
  end
end