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

  has_many :tasks
  has_many :projects

  before_create :assign_role

  def assign_role
    # assign a default role if no role is assigned
    self.add_role :user if self.roles.first.nil?
  end

  def completed_count
    self.tasks.completed.count
  end
end
