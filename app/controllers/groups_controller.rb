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
    if params[:group].nil?
      redirect_to group_path(@group)
    else
      if @group.update_attributes(params_group)
        redirect_to group_path(@group), :notice => 'Group Successfully Updated'
      else
        flash.now[:error] = @group.errors.full_messages.join(', ')
        render :edit
      end
    end
  end

  def show
    @complete_projects, @incomplete_projects = @group.projects.partition(&:completed)

    @complete_tasks, @incomplete_tasks = @group.tasks.partition(&:completed)

    @user_tasks = current_user.tasks.where(:group_id => @group.id)
  end

  def destroy
    @group.destroy
    redirect_to root_path
  end

  def edit
    @owner = @group.owner_id
    @group_users = @group.users
    if params[:invites].present?
      @invite = true
    end
  end

  def index
    @groups = current_user.groups
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
      :invites_attributes => [:email, :user_id, :_destroy]
    )
  end
end