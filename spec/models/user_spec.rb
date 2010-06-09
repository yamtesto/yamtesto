require 'spec_helper'

describe User do
  describe "account creation" do
    it "should create verification tag" do
      user = User.create(:email => Faker::Internet.email)
      user.verification_tag.should_not be_nil
      user.verification_tag.should_not == ""
    end
  end
end
