require 'spec_helper'

describe ApplicationController do
  describe "authentication" do
    it "should authenticate" do
      # create fake action to call method
      class ApplicationController
        def authenticate_fake
          user = params[:user]
          pwd = params[:password]
          render :status => 401 unless authenticate(user, pwd)
        end
      end
      user = User.make
      user.password = "pass"
      user.save
      get :authenticate_fake, {:user => user, :password => "pass"}
      user.reload
      session[:user_id].should == user.id
      session[:session_key].should == user.session_key
    end
  end
end
