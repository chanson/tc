 class TaskObserver < ActiveRecord::Observer
  observe :task

  def after_create(task)
    project = task.project
    if project.present?
      if project.group.present?
        task.update_attribute :group_id, project.group_id
      end
      if task.deadline.utc > project.deadline.utc
        task.update_attribute :deadline, project.deadline
      end
    end

    if task.user_id.nil?
      task.update_attribute :user_id, project.user_id
    end
  end

  def after_update(task)
    project = task.project
    if project.present?
      unless project.tasks.incomplete.any?
        project.update_attribute :completed, true
      end

      if task.deadline.utc > project.deadline.utc
        task.update_attribute :deadline, project.deadline
      end
    end
  end
end