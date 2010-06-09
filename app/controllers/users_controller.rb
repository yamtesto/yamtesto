class UsersController < ApplicationController
  before_filter :check_logged_in, :except => [:new, :create, :login, :activate]
  before_filter :check_owner, :only => [:edit, :update, :destroy]

  # GET /users
  def index
    @user = @logged_in_user
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
    @jobs = @user.get_jobs
  end

 # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    if @user.noob?
      redirect_to register_user_path(@user)
    else
      @job = Job.new
      @jobs = @user.get_jobs
    end
  end

  # POST /users
  def create
    @user = User.new(params[:user])

    if @user.save
      Emailer.deliver_confirmation(@user)
      render :text => 'Check your email for the confirmation email'
    else
      render :action => "new"
    end
  end

  # PUT /users/1
  def update
    if @user.update_attributes(params[:user])
      if @user.activation_incomplete?
        @user.complete_activation! # show this only once
        redirect_to(edit_user_path(@user), :notice => 'Now fill out some more info')
      else
        redirect_to(@user, :notice => 'User was successfully updated.')
      end
    else
      flash[:warning] = "something went wrong!"
      redirect_to(edit_user_path(@user))
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
        @user.create_session_key!
        session[:user_id] = @user.id
        session[:session_key] = @user.session_key
        redirect_to register_user_path(@user.id)
      else
        flash[:warning] = "could not activate"
        redirect_to :action => "new"
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
      flash[:warning] = "could not login"
      redirect_to :action => "new"
    end
  end

  def logout
    session[:user_id] = nil
    session[:session_key] = nil
    redirect_to root_url
  end

  ### jobs
  def add_job
    user = User.find(params[:id])
    title = params[:job].andand[:title].to_s
    company = params[:job].andand[:company].to_s
    if user.nil?
      flash[:warning] = "who are you again?"
      redirect_to edit_user_path
    elsif title.blank? || company.blank?
      flash[:warning] = "job needs both company and title"
      redirect_to edit_user_path
    else
      begin
        user.jobs << Job.find_or_create_by_title_and_company(title, company)
        redirect_to edit_user_path, :notice => "successfully added new job"
      rescue
        flash[:warning] = "failed to add this job (maybe already in your job history?)"
        redirect_to edit_user_path
      end
    end
  end

  def edit_job
    user = User.find(params[:id])
    job = Job.find(params[:job].andand[:id])
    title = params[:job].andand[:title].to_s
    company = params[:job].andand[:company].to_s
    if user.nil? || job.nil?
      flash[:warning] = "who are you again?"
      redirect_to edit_user_path
    elsif title.blank? || company.blank?
      flash[:warning] = "job needs both company and title"
      redirect_to edit_user_path
    else
      begin
        new_job = Job.find_or_create_by_title_and_company(title, company)
        if new_job != job
          user.jobs << new_job
          user.jobs.delete(job)
        end
        redirect_to edit_user_path, :notice => "successfully updated job"
      rescue
        flash[:warning] = "failed to add this job (maybe already in your job history?)"
        redirect_to edit_user_path
      end
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
