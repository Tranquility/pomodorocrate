class UsersController < ApplicationController
  
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => [:index, :destroy]
  
  def new
    @title = "Sign up"
    @user = User.new
    render :layout => "login"
  end
  
  def index
    @users = User.paginate(:page => params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
  
  def create
    @user = User.new(params[:user])
    @user.account = Account.find_by_name("beta") # hard coded beta
    if @user.save
      
      UserMailer.new_account_confirmation_email(@user).deliver
      
      sign_in @user
      flash[:success] = "Welcome to Pomodoro Crate!"
      redirect_to edit_user_path(@user)
      #redirect_to user_confirm_path
    else
      @title = 'Sign up'
      render 'new', :layout => "login"
    end
  end
  
  def edit
    @user = User.find(params[:id])
    @title = "Edit user"
  end
  
  def update
    @user = User.find(params[:id])
    
    if @user.id != current_user.id
      flash[:error] = "Illegal access attempt."
      redirect_to activities_path and return
    end
    
    if params[:user][:settings_page] and params[:user][:password].empty?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to edit_user_path(@user)
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  
  def email_reset_password
    
    @user = User.find_by_email(params[:user][:email])
    
    unless @user
      flash[:error] = "Email is not valid or no user exists with this address"
      redirect_to reset_password_path and return
    end
    
    @user.make_reset_password_hash
    if @user.update_attribute(:reset_password_hash, @user.reset_password_hash)
      
      UserMailer.reset_password_email(@user, edit_password_url(:reset_password_hash => @user.reset_password_hash)).deliver
      
      flash[:success] = "An email with instructions on how to reset your password has been sent."
      redirect_to signin_path
    else
      flash[:error] = "An error has occured while trying to initiate the password reset"
      redirect_to reset_password_path
    end
  end
  
  def edit_password
    @user = User.find_by_reset_password_hash(params[:reset_password_hash])
    if @user
      @user.update_attribute(:reset_password_hash, nil)
      
      sign_in @user
      flash[:notice] = "Please edit your password"
      redirect_to edit_user_path(@user)
    else
      flash[:error] = "Invalid reset password hash"
      redirect_to reset_password_path
    end
  end
  
  def timezone
    @user = User.find(params[:id])
    
    if @user.update_attribute(:time_zone, params[:user][:time_zone])
      flash[:success] = "Profile updated."
    else
      flash[:error] = "Profile update failed."
    end
    render 'edit'
  end
  
  private
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
