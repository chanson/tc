class Task < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  before_validation :set_defaults

  validates :name, :presence => true, :length => { :maximum => 255 }
  validates :repeatable, :inclusion => { :in => [true, false] }
  validates :completed, :inclusion => { :in => [true, false] }
  validates :deadline, :presence => true

  validate :valid_deadline
  validate :deadline_before_project_deadline

  belongs_to :user
  belongs_to :project
  belongs_to :group

  with_options(:if => :repeatable) do |t|
    t.validates_presence_of :repeat_type
  end

  module Deadlines
    EXPIRED = 'expired'
    TODAY = 'today'
    TOMORROW = 'tomorrow'
    WEEK = 'week'
    MONTH = 'month'
    FUTURE = 'future'

    ANY = 'any'

    ALL = [EXPIRED, TODAY, TOMORROW, WEEK, MONTH, FUTURE]
  end

  #Scopes
  scope :completed, where(:completed => true)
  scope :incomplete, where(:completed => false)

  def self.with_deadline(deadline)
    deadline = Task::Deadlines::ANY if deadline.blank?
    case deadline
    when Task::Deadlines::EXPIRED
      where("deadline < ? AND completed = false", Time.now.utc)
    when Task::Deadlines::TODAY
      where("deadline = ?", Date.today)
    when Task::Deadlines::TOMORROW
      where("deadline > ? AND deadline <= ?", Time.now.utc, 1.day.from_now)
    when Task::Deadlines::WEEK
      where("deadline > ? AND deadline <= ?", 1.day.from_now, 1.week.from_now)
    when Task::Deadlines::MONTH
      where("deadline > ? AND deadline <= ?", 1.week.from_now, 1.month.from_now)
    when Task::Deadlines::FUTURE
      where("deadline > ?", 1.month.from_now)
    when Task::Deadlines::ANY
      scoped
    else
      raise IndexError, "unknown task deadline '#{deadline}'"
    end
  end

  def self.for_user(user_id)
    where(:user_id => user_id)
  end

  def self.standalone_for_user(user_id)
    where(:user_id => user_id, :completed => false, :project_id => :null)
  end

  #Methods

  def self.group_by_deadline
    tasks_hash = {}
    Task::Deadlines::ALL.map do |deadline|
      tasks = self.with_deadline(deadline)
      if tasks.any?
        tasks_hash = tasks_hash.merge({ deadline.to_sym => tasks })
      end
    end
    tasks_hash
  end

  def user_name
    self.user.name
  end

  private

  def deadline_before_project_deadline
    if self.project.present? && deadline.utc < self.project.deadline.utc
      self.errors.add :deadline, ' must be before the deadline of the parent project (all dates are in UTC time).'
    end
  end

  def set_defaults
    self.repeatable ||= false
    self.completed ||= false

    true
  end

  def valid_deadline
    if deadline.utc < Time.now.utc
      self.errors.add :deadline, ' has to be on or after today (all dates are in UTC time).'
    end
  end
end