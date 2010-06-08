require 'spec_helper'

describe "/users/show.html.erb" do
  include UsersHelper
  before(:each) do
    assigns[:user] = @user = stub_model(User,
      :email => "value for email",
      :activated => false,
      :first_name => "value for first_name",
      :last_name => "value for last_name",
      :password => "value for password",
      :birth_date => "value for birth_date",
      :location => "value for location"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ email/)
    response.should have_text(/false/)
    response.should have_text(/value\ for\ first_name/)
    response.should have_text(/value\ for\ last_name/)
    response.should have_text(/value\ for\ password/)
    response.should have_text(/value\ for\ birth_date/)
    response.should have_text(/value\ for\ location/)
  end
end
