class User < ActiveRecord::Base
  has_and_belongs_to_many :jobs
  validates_presence_of :email
  validates_uniqueness_of :email
  after_create :generate_activation_tag!
  accepts_nested_attributes_for :jobs

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
    self.first_name.blank? || self.last_name.blank? || self.password.blank?
  end

  def password=(pwd)
    unless pwd.blank?
      self[:password] = Digest::SHA2.hexdigest(pwd)
    end
  end

  def can_has_access?(pwd)
    if Digest::SHA2.hexdigest(pwd) == self.password
      create_session_key!
    end
  end

  def create_session_key!
    self.session_key = UUIDTools::UUID.timestamp_create().to_s
    self.save!
  end

  def get_jobs
    jobs.last(7).reverse
  end
end
