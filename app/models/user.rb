class User < ActiveRecord::Base
  has_and_belongs_to_many :jobs
  validates_presence_of :email
  validates_uniqueness_of :email
  after_create :generate_activation_tag!
  accepts_nested_attributes_for :jobs

  ACTIVATION_STATUS = {:not_activated => 0, :incomplete => 1, :complete => 2}
  def generate_activation_tag!
    self.activation_tag = UUIDTools::UUID.timestamp_create().to_s
    self.activated = ACTIVATION_STATUS[:not_activated]
    save!
  end

  def activate!(tag)
    if activation_tag == tag
      self.activated = ACTIVATION_STATUS[:incomplete]
      self.save!
    end
  end

  def activation_incomplete?
    self.activated != ACTIVATION_STATUS[:complete]
  end

  def complete_activation!
    self.activated = ACTIVATION_STATUS[:complete]
    self.save
  end

  def noob?
    # self.first_name.blank? || self.last_name.blank? || self.password.blank?
    activation_incomplete?
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
