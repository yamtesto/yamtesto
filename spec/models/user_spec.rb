require 'spec_helper'

describe User do
  describe "account creation" do
    it "should create activation tag" do
      user = User.create(:email => Faker::Internet.email)
      user.activation_tag.should_not be_nil
      user.activation_tag.should_not == ""
    end

    it "missing basic params means you're a noob" do
      user = User.create(:email => Faker::Internet.email)
      user.should be_noob
    end
  end

  it "should digest password on save" do
    password_phrase = "hello"
    user = User.make
    user.password = password_phrase
    user.save
    user.password.should == Digest::SHA2.hexdigest(password_phrase)
  end

  it "should check access" do
    password_phrase = "hello"
    user = User.make
    user.password = password_phrase
    user.save
    user.can_has_access?(password_phrase).should be_true
  end

end
