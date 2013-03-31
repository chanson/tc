class TasksController < ApplicationController
  before_filter :find_task, :only => [:edit, :update, :show, :destroy]
  before_filter :find_task_two, :only => [:complete_task]

  def create
    @task = Task.create(task_params.merge({ :user_id => current_user.id }))

    puts params[:task]

    if @task.save
      redirect_to tasks_path, :notice => 'Task created.'
    else
      flash[:error] = @task.errors.full_messages.join(', ')
      render :edit
    end
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def update
    if @task.update_attributes(task_params)
      redirect_to tasks_path
    else
      render :edit
    end
  end

  def index
    user_tasks = Task.for_user(current_user)
    @tasks = {}
    Task::Deadlines::ALL.map do |deadline|
      tasks = user_tasks.with_deadline(deadline)
      if tasks.any?
        @tasks = @tasks.merge({ deadline.to_sym => tasks })
      end
    end
  end

  def show
  end

  def destroy
    @task.destroy
    redirect_to tasks_path
  end

  def complete_task
    if @task.update_attributes({ :completed => !@task.completed })
      redirect_to tasks_path, :success => 'Task updated.'
    else
      render :index, :error => 'Could not update task.'
    end
  end

  private

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
      :completed
    )
  end
end