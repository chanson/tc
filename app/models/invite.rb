class Invite < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  before_validation :normalize_email

  belongs_to :user
  belongs_to :group

  validates :user_id, :presence => true
  validates :email, :presence => true
  validates_email_format_of :email

  private

  def normalize_email
    email.try(:downcase!)
  end
end