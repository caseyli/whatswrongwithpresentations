class SessionsController < ApplicationController
  include SessionsHelper
  require 'uri'
  require 'restclient' # https://github.com/archiloque/rest-client
  
  def new
    @title = "Sign in"
  end
  
  def create
    # GitKit
    user = User.authenticate params[:email], params[:password]
                                        
    if user.nil?
      respond_to do |format|    
        format.json { render :json => { :status => "passwordError" }.to_json }
      end
    else
      sign_in user
      respond_to do |format|
        format.json { render :json => { :status => "OK" }.to_json }
      end
    end
  end
  
  def callback
    api_params = {
      'requestUri' => request.url,
      'postBody' => request.post? ? request.raw_post : URI.parse(request.url).query
    }
  
    api_url = "https://www.googleapis.com/identitytoolkit/v1/relyingparty/" +
    "verifyAssertion?key=AIzaSyCy_2YFMWPYA412Q0sKvU22kSVZYdw2hro"
  
    assertion = get_assertion(api_url, api_params)
    if !assertion.nil? && !assertion["verifiedEmail"].nil?
        @user = User.find_by_email(assertion["verifiedEmail"])
        if @user.nil?
          @user = User.new
          @user.email = assertion["verifiedEmail"]
          @user.display_name = assertion["displayName"]
          @user.first_name = assertion["firstName"]
          @user.last_name = assertion["lastName"]
          @user.save(:validate => false)
        end
        sign_in @user
    else
      # handle bad login
    end
  end
  
  def destroy
    sign_out
    respond_to do |format|
      format.html { redirect_to root_path }
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
    

   def get_assertion(url, params)
      begin
        api_response = RestClient.post(url, params.to_json, :content_type => :json )
        verified_assertion = JSON.parse(api_response)
        raise StandardError unless verified_assertion.include? "verifiedEmail"
        return verified_assertion
      rescue StandardError => error
        return nil
      end
    end
  


end
