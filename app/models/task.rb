class Task < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  before_validation :set_defaults

  validates :name, :presence => true, :length => { :maximum => 255 }
  validates :repeatable, :inclusion => { :in => [true, false] }
  validates :completed, :inclusion => { :in => [true, false] }

  belongs_to :user

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
  def self.with_deadline(deadline)
    deadline = Task::Deadlines::ANY if deadline.blank?
    case deadline
    when Task::Deadlines::EXPIRED
      where("deadline < ? AND completed = false", Date.today)
    when Task::Deadlines::TODAY
      where("deadline = ?", Date.today)
    when Task::Deadlines::TOMORROW
      where("deadline > ? AND deadline <= ?", Date.today, Date.tomorrow)
    when Task::Deadlines::WEEK
      where("deadline > ? AND deadline <= ?", Date.tomorrow, 1.week.from_now)
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

  #Methods

  def user_deadline
    if deadline < Date.today
      Task::Deadlines::EXPIRED
    elsif deadline = Date.today
      Task::Deadlines::TODAY
    elsif deadline < Date.tomorrow
      Task::Deadlines:: TOMORROW
    elsif deadline < 1.week.from_now
      Task::Deadlines::WEEK
    elsif deadline < 1.month.from_now
      Task::Deadlines::MONTH
    else
      Task::Deadlines::FUTURE
    end
  end

  private

  def set_defaults
    self.repeatable ||= false
    self.completed ||= false

    true
  end
end