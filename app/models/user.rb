class User < ActiveRecord::Base
  has_and_belongs_to_many :jobs
  validates_presence_of :email
  validates_uniqueness_of :email
end
