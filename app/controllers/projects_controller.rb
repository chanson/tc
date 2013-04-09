class ProjectsController < ApplicationController
  before_filter :find_project, :only => [:edit, :update, :show, :destroy]
  before_filter :find_user_tasks, :only => [:new, :edit]

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.new(params_project)

    if @project.save
      redirect_to projects_path, :notice => 'Project Created'
    else
      flash.now[:error] = @project.errors.full_messages.join(', ')
      render :new
    end
  end

  def update
    if @project.update_attributes(project_params)
      redirect_to projects_path
    else
      flash.now[:error] = @project.errors.full_messages.join(', ')
      render :edit
    end
  end

  def show
    user_tasks = @project.tasks
    @tasks = {}
    Task::Deadlines::ALL.map do |deadline|
      tasks = user_tasks.with_deadline(deadline)
      if tasks.any?
        @tasks = @tasks.merge({ deadline.to_sym => tasks })
      end
    end
  end

  def edit

  end

  def index
    @projects = Project.active_for_user(current_user).order(&:deadline)
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
      :tasks_attributes => [:name, :description, :_destroy, :deadline, :completed],
      :task_ids => []
    )
  end

  def find_project
    @project = Project.find(params[:ids])
  end

  def find_user_tasks
    @tasks = Task.for_user(current_user)
  end
end