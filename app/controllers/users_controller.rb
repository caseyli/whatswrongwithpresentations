class UsersController < ApplicationController

  before_filter :authenticate, :except => [:new, :create, :show, :registered]
  before_filter :admin_user, :only => [:index, :destroy]
  before_filter :correct_user, :only => [:edit, :update, :show]
  
  def new
    @user = User.new
    @title = "Register"
    @user.email = params[:email]
  end
  
  def index
    @users = User.all
    @title = "Users"
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.email
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to WWWP!"
      
      respond_to do |format|
        format.html { redirect_to root_path }
        format.json { render :json => '{ "response" : "true" }' }
      end
      
    else
      @title = "Register"
      
      respond_to do |format|
        format.html { render 'new' }
        format.json { render :json => '{ "response" : "false", "message" : "Sorry could not create user." }' }
      end
    end
  end

  def edit
  end

  def update
  end
  
  def registered
    #if request.post?
      @user = User.find_by_email(params[:email])
      respond_to do |format|
        format.json { render :json => { :registered => !@user.nil?}.to_json }
      end
    #end
  end

  private
   
    def correct_user
      @user = User.find(params[:id])
      respond_to do |format|
        format.html { redirect_to(root_path) unless current_user?(@user) }
      end
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
