require 'spec_helper'

describe "/users/index.html.erb" do
  include UsersHelper

  before(:each) do
    assigns[:users] = [
      stub_model(User,
        :email => "value for email",
        :activated => false,
        :first_name => "value for first_name",
        :last_name => "value for last_name",
        :password => "value for password",
        :birth_date => "value for birth_date",
        :location => "value for location"
      ),
      stub_model(User,
        :email => "value for email",
        :activated => false,
        :first_name => "value for first_name",
        :last_name => "value for last_name",
        :password => "value for password",
        :birth_date => "value for birth_date",
        :location => "value for location"
      )
    ]
  end

  it "renders a list of users" do
    render
    response.should have_tag("tr>td", "value for email".to_s, 2)
    response.should have_tag("tr>td", false.to_s, 2)
    response.should have_tag("tr>td", "value for first_name".to_s, 2)
    response.should have_tag("tr>td", "value for last_name".to_s, 2)
    response.should have_tag("tr>td", "value for password".to_s, 2)
    response.should have_tag("tr>td", "value for birth_date".to_s, 2)
    response.should have_tag("tr>td", "value for location".to_s, 2)
  end
end
