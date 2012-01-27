class SessionsController < ApplicationController
  include SessionsHelper
  
  def new
    @title = "Sign in"
  end
  
  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
                                        
    if user.nil?
      @title = "Sign in"
      message = "Invalid E-mail or Password."
      flash[:error] = message
      
      respond_to do |format|
        format.html { render 'new' }
        format.json { render :json => '{ "response" : "false", "message" : "' + message + '" }' }
        
      end
      
    else
      flash[:success] = "Welcome back to WWWP"
      sign_in user
      
      respond_to do |format|
        format.html { redirect_back_or(root_path) }
        format.json { render :json => '{ "response" : "true" }' }
      end
      
    end
  end
  
  def destroy
    sign_out
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render :json => '{ "response" : "true" }' }
    end
    
  end
  
  def signed_in
    if signed_in?
      response = '{ "response" : "true" }'
    else
      response = '{ "response" : "false" }'
    end
    respond_to do |format|
      format.json { render :json => response }
    end
  end
    
  private 
    
    def authenticate?(username, password)
      @user = User.authenticate(username, password)
      if !@user.nil?
        true
      else
        false
      end
    end

end
