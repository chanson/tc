class HomeController < ApplicationController
  def index
    @users = User.all
  end

  def authed
    @user = current_user
    @tasks = Task.for_user(current_user).group_by_deadline

    projs = Project.for_user(current_user)
    @projects = projs.order(&:deadline).limit(5)
    @other_projects_count = projs.count - 5

    grps = @user.groups
    @groups = grps.limit(5)
    @other_groups_count = grps.count - 5
  end
end