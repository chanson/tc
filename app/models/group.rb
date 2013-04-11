class Group < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  image_accessor :logo_image

  has_and_belongs_to_many :users

  has_many :projects
  has_many :tasks
  has_many :invites

  accepts_nested_attributes_for :invites, :allow_destroy => true, :reject_if => :all_blank

  validates :name, :presence => true
  validates :owner_id, :presence => true
end