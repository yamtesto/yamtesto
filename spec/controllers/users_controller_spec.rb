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
      @user = User.make(:first_name => "")
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

  describe "jobs" do
    it "should add jobs" do
      user = User.make
      company = Faker::Company.name
      title = Faker::Company.catch_phrase
      
      login_as user
      post :add_job, :id => user.id, :job => {:title => title, :company => company}
      response.should redirect_to(edit_user_path(user.id))
      user = User.find(user.id)
      user.jobs.length.should == 1
      user.jobs.first.title.should == title
      user.jobs.first.company.should == company
    end

    it "should only take jobs with title and company" do
      user = User.make
      company = Faker::Company.name
      title = Faker::Company.catch_phrase
      
      login_as user
      post :add_job, :id => user.id, :job => {:title => title, :company => ""}
      response.should_not be_success
      user = User.find(user.id)
      user.jobs.length.should == 0
    end

    it "should not be able to list two same jobs" do
      user = User.make
      job = Job.make
      user.jobs << job
      user.jobs << job rescue nil
      user.jobs.length.should == 1
    end

    it "should be able to edit jobs" do
      user = User.make
      job = Job.make(:title => "peon")
      user.jobs << job
      new_title = "CEO"
      same_company = job.company

      login_as user
      post :edit_job, :id => user.id, :job => {:id => job.id, :title => new_title, :company => same_company}
      response.should be_success

      user = User.find(user.id)
      user.jobs.length.should == 1
      user.jobs.first.title = new_title
      user.jobs.first.company = same_company
    end
  end
end
