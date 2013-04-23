class TasksController < ApplicationController
  before_filter :find_task, :only => [:edit, :update, :show, :destroy]
  before_filter :find_task_two, :only => [:complete_task]
  before_filter :find_group, :only => [:edit, :new]

  def create
    @task = Task.create(task_params.merge({ :user_id => current_user.id }))

    respond_to do |format|
      if @task.save
        format.html { redirect_to task_path(@task), notice: 'Task was successfully created.' }
        format.json { render json: @task, status: :created, location: @task }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def update
    if @task.update_attributes(task_params)
      if request.xhr?
        head :ok
      else
        redirect_to tasks_path
      end
    else
      render :edit
    end
  end

  def index
    @tasks = Task.for_user(current_user).group_by_deadline
  end

  def show
    @group = @task.group
    @project = @task.project
  end

  def destroy
    @task.destroy
    redirect_to tasks_path
  end

  def complete_task
    if @task.update_attributes({ :completed => !@task.completed })
      if @task.group_id.present?
        redirect_to group_path(@task.group), :success => 'Task completed.'
      else
        redirect_to tasks_path, :success => 'Task completed.'
      end
    else
      render :index, :error => 'Could not complete task.'
    end
  end

  private

  def find_group
    if params[:group_id].present?
      @group = Group.find(params[:group_id])
    else
      @group = @project.try(:group_id) || nil
    end
  end

  def find_task
    @task = Task.find(params[:id])
  end

  def find_task_two
    @task = Task.find(params[:task_id])
  end

  def task_params
    params.require(:task).permit(
      :name,
      :user_id,
      :description,
      :deadline,
      # :"deadline(1i)",
      # :"deadline(2i)",
      # :"deadline(3i)",
      :repeatable,
      :repeat_type,
      :completed,
      :group_id,
      :tasks_attributes
    )
  end
end