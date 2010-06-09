class UsersController < ApplicationController
  before_filter :check_logged_in, :except => [:new, :login, :activate]
  before_filter :check_owner, :only => [:edit, :update, :destroy]
  # GET /users
  def index
    @user = @logged_in_user
    # test!
    # Emailer.deliver_confirmation("hc5duke@gmail.com")

  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    redirect_to register_user_path(@user) if @user.noob?
  end

  # POST /users
  def create
    @user = User.new(params[:user])

    if @user.save
      format.html { redirect_to(@user, :notice => 'User was successfully created.') }
    else
      format.html { render :action => "new" }
    end
  end

  # PUT /users/1
  def update
    if @user.update_attributes(params[:user])
      if @user.birth_date.nil? && @user.location.nil? && @user.jobs.empty?
        redirect_to(edit_user_path(@user), :notice => 'Now fill out some more info')
      else
        redirect_to(@user, :notice => 'User was successfully updated.')
      end
    else
      render :action => "edit"
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to(users_url)
  end

  def activate
    if params[:id] && params[:tag]
      @user = User.find(params[:id])
      if @user.activate!(params[:tag])
        # success!
        redirect_to register_user_path(@user.id)
      else
        render :status => 401 # wrong activation tag
      end
    else
      redirect_to root_url
    end
  end

  # like edit but simpler
  def register
    @user = @logged_in_user
    redirect_to edit_user_path(@user) unless @user.noob?
  end

  def login
    redirect_to :action => "new" if params[:user].nil?
    @user = User.find_by_email(params[:user][:email])
    password = params[:user][:password]
    if authenticate(@user, password)
      redirect_to users_path
    else
      render :status => 401 # bad password
    end
  end

  private
  def check_logged_in
    redirect_to :action => "new" unless logged_in?
  end

  def check_owner
    @user = User.find(params[:id])
    if @logged_in_user == @user
      true
    else
      redirect_to @logged_in_user
    end
  end
end
