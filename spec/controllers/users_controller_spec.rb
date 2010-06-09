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

  it "should activate users" do
    @user = User.make
    get :activate, { :id => @user.id, :tag => @user.activation_tag }
    response.should be_success
    @user.reload.should be_activated
  end
  it "should deny activation" do
    @user = User.make
    get :activate, { :id => @user.id, :tag => "#{@user.activation_tag}0000" }
    response.should_not be_success
    @user.reload.should_not be_activated
  end
end
