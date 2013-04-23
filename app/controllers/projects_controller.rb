class ProjectsController < ApplicationController
  before_filter :find_project, :only => [:edit, :update, :show, :destroy]
  before_filter :find_user_tasks, :only => [:new, :edit]
  before_filter :find_group, :only => [:new, :edit]

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.new(params_project)

    if @project.save
      redirect_to project_path(@project), :notice => 'Project Created'
    else
      flash.now[:error] = @project.errors.full_messages.join(', ')
      render :new
    end
  end

  def update
    if @project.update_attributes(params_project)
      redirect_to project_path(@project)
    else
      flash.now[:error] = @project.errors.full_messages.join(', ')
      render :edit
    end
  end

  def show
    @tasks = @project.tasks.group_by_deadline
    @group = @project.group
  end

  def edit
    if params[:tasks_only].present?
      @tasks_only = true
    end
  end

  def index
    @projects = Project.for_user(current_user).order(&:deadline)
  end

  def destroy
    @project.destroy
    redirect_to projects_path
  end

  private

  def params_project
    params.require(:project).permit(
      :user_id,
      :description,
      :name,
      :deadline,
      :completed,
      :group_id,
      :tasks_attributes => [:name, :description, :_destroy, :deadline, :completed, :id],
      :task_ids => []
    )
  end

  def find_group
    if params[:group_id].present?
      @group = Group.find(params[:group_id])
    else
      @group = @project.group
    end
  end

  def find_project
    @project = Project.find(params[:id])
  end

  def find_user_tasks
    @tasks = Task.for_user(current_user)
  end
end