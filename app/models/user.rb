require 'uuidtools'

class User < ActiveRecord::Base
  has_and_belongs_to_many :jobs
  validates_presence_of :email
  validates_uniqueness_of :email
  after_create :generate_activation_tag!
  before_save :digest_password

  def generate_activation_tag!
    self.activated = false
    self.activation_tag = UUIDTools::UUID.timestamp_create().to_s
    save!
  end

  def activate!(tag)
    if activation_tag == tag
      self.activated = true
      self.save!
    end
  end

  def noob?
    self.first_name.nil? || self.last_name.nil? || self.password.nil?
  end

  def digest_password
    self.password = Digest::SHA2.hexdigest(self.password) if self.password
  end

  def can_has_access?(pwd)
    if Digest::SHA2.hexdigest(pwd) == self.password
      self.session_key = UUIDTools::UUID.timestamp_create().to_s
      self.save!
    end
  end
end
