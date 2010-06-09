require 'spec_helper'

describe UsersController do
  it "should boot unregistered users" do
    get :index
    response.should redirect_to(new_user_url)
  end

  it "should not boot logged in users" do
    @user = User.make
    login_as @user
    get :index
    response.should be_success
    # try logging out
    logout
    get :index
    response.should redirect_to(new_user_url)
  end
end

