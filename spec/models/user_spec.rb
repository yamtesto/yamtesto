require 'spec_helper'

describe User do
  before(:each) do
    @valid_attributes = {
      :email => "value for email",
      :activated => false,
      :first_name => "value for first_name",
      :last_name => "value for last_name",
      :password => "value for password",
      :birth_date => "value for birth_date",
      :location => "value for location"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end
end
