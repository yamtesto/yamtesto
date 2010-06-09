class UsersController < ApplicationController
  before_filter :check_logged_in, :except => [:new, :login, :activate]
  # GET /users
  # GET /users.xml
  def index
    # test!
    # Emailer.deliver_confirmation("hc5duke@gmail.com")

  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

  def activate
    if params[:id] && params[:tag]
      @user = User.find(params[:id])
      if @user.activate!(params[:tag])
        # success!
      else
        render :status => 401 # wrong activation tag
      end
    else
      redirect_to root_url
    end
  end

  def login
    redirect_to :action => "new" if params[:user].nil?
    @user = User.find_by_email(params[:user][:email])
    password = params[:user][:password]
    if authenticate(@user, password)
      redirect_to :action => "index"
    else
      render :status => 401 # bad password
    end
  end

  private
  def check_logged_in
    redirect_to :action => "new" unless logged_in?
  end
end
