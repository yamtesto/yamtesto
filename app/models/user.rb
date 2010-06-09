require 'uuidtools'

class User < ActiveRecord::Base
  has_and_belongs_to_many :jobs
  validates_presence_of :email
  validates_uniqueness_of :email
  after_create :generate_activation_tag!

  def generate_activation_tag!
    activated = false
    activation_tag = UUIDTools::UUID.timestamp_create().to_s
    save
  end

  def activate!(tag)
    if activation_tag == tag
      self.activated = true
      self.save
    end
  end
end
