require 'spec_helper'

describe UsersController do
  describe "registration process" do
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
      @user.reload.should be_activated
      response.should redirect_to(register_user_path)
    end

    it "should deny activation" do
      @user = User.make
      get :activate, { :id => @user.id, :tag => "#{@user.activation_tag}0000" }
      response.should_not be_success
      @user.reload.should_not be_activated
    end

    it "should complete registration if name and password are filled out" do
      @user = User.make(:first_name => Faker::Name.first_name,
          :last_name => Faker::Name.last_name,
          :password => "password")
      login_as @user
      get :register
      response.should redirect_to edit_user_path(@user)
    end

    it "should get user to complete registration if name and password are missing" do
      @user = User.make(:first_name => Faker::Name.first_name)
      login_as @user
      get :edit, :id => @user.id
      response.should redirect_to register_user_path(@user)
    end

    it "should tell the user to finish registration" do
      @user = User.make
      login_as @user
      params = {
        :id => @user.id,
        :user => {
          :first_name => Faker::Name.first_name,
          :last_name => Faker::Name.last_name,
          :password => "pass"
        }
      }
      get :update, params
      response.should redirect_to(edit_user_path)
    end
  end

  describe "authentication" do
    it "should authenticate users" do
      logout
      @user = User.make
      @user.password = "something"
      @user.save!
      get :login, :user => {:email => @user.email, :password => "something"}
      session[:user_id].should == @user.id
      session[:session_key].should == @user.reload.session_key

      response.should redirect_to(users_path)
    end

    it "should deny users" do
      logout
      @user = User.make
      @user.password = "something"
      @user.save!
      get :login, :user => {:email => @user.email, :password => "not_something"}
      session[:user_id].should be_nil
      session[:session_key].should be_nil

      response.should_not be_success
      response.should_not be_redirect
    end
  end
end
