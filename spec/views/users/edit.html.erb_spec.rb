require 'spec_helper'

describe "/users/edit.html.erb" do
  include UsersHelper

  before(:each) do
    assigns[:user] = @user = stub_model(User,
      :new_record? => false,
      :email => "value for email",
      :activated => false,
      :first_name => "value for first_name",
      :last_name => "value for last_name",
      :password => "value for password",
      :birth_date => "value for birth_date",
      :location => "value for location"
    )
  end

  it "renders the edit user form" do
    render

    response.should have_tag("form[action=#{user_path(@user)}][method=post]") do
      with_tag('input#user_email[name=?]', "user[email]")
      with_tag('input#user_activated[name=?]', "user[activated]")
      with_tag('input#user_first_name[name=?]', "user[first_name]")
      with_tag('input#user_last_name[name=?]', "user[last_name]")
      with_tag('input#user_password[name=?]', "user[password]")
      with_tag('input#user_birth_date[name=?]', "user[birth_date]")
      with_tag('input#user_location[name=?]', "user[location]")
    end
  end
end
