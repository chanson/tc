class Group < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  image_accessor :logo_image

  has_and_belongs_to_many :users

  has_many :projects, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :invites, :dependent => :destroy

  accepts_nested_attributes_for :invites, :allow_destroy => true, :reject_if => :all_blank

  validates :name, :presence => true
  validates :owner_id, :presence => true

  def owner_name
    User.find(self.owner_id).name
  end

  def completed_tasks_count
    self.tasks.completed.count
  end

  def completed_projects_count
    self.projects.completed.count
  end

  def active_tasks_count
    self.tasks.incomplete.count
  end

  def active_projects_count
    self.projects.incomplete.count
  end
end