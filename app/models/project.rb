class Project < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  before_validation :set_defaults

  validates :name, :presence => true, :length => { :maximum => 255 }
  validates :completed, :inclusion => { :in => [true, false] }

  belongs_to :user
  belongs_to :group

  has_many :tasks, :dependent => :destroy
  accepts_nested_attributes_for :tasks, :allow_destroy => true, :reject_if => :all_blank

  #scopes
  scope :completed, where(:completed => true)
  scope :incomplete, where(:completed => false)

  def self.for_user(user_id)
    where(:user_id => user_id, :group_id => nil)
  end

  #methods
  def completed_tasks
    self.tasks.where(:completed => true)
  end

  def uncompleted_tasks
    self.tasks.where(:completed => false)
  end

  def user_name
    self.user.name
  end

  private

  def set_defaults
    self.completed ||= false

    return true
  end
end