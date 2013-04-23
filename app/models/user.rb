class User < ActiveRecord::Base
  # include ActiveModel::ForbiddenAttributesProtection

  image_accessor :avatar_image

  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :avatar_image, :retained_avatar_image, :remove_avatar_image

  has_many :tasks, :dependent => :destroy
  has_many :projects, :dependent => :destroy
  has_many :invites, :dependent => :destroy

  has_and_belongs_to_many :groups

  before_create :assign_role

  def assign_role
    # assign a default role if no role is assigned
    self.add_role :user if self.roles.first.nil?
  end

  def completed_count
    self.tasks.completed.count
  end

  def completed_projects_count
    self.projects.completed.count
  end

  def active_count
    self.tasks.incomplete.count
  end

  def active_projects_count
    self.projects.incomplete.count
  end
end
