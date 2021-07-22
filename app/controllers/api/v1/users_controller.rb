class Api::V1::UsersController < Api::V1::ApplicationController

  before_action :authenticate_api_user, except: [:sign_in, :sign_up, :forgot_password]

  require 'jwt'

  def sign_in
    begin
      raise "Incomplete Params" if !params[:email].present? || !params[:password].present?
      @user = User.find_by(email: params[:email])
      raise "Email or Password is incorrect" if @user.nil? || !@user.valid_password?(params[:password])
      user = @user.as_json(except: [:device_id, :device_type, :password])
      payload = { "data": user, exp: expire_time }
      hsh = {}
      hsh[:message] = "Log-In Successfully"
      hsh[:token] = JWT.encode payload, hmac_secret, 'HS256'
      hsh[:user] = user
      render :json => hsh.to_json
    rescue Exception => e
      error_handle_bad_request(e)
    end
  end

  def sign_up
    begin
      raise "Incomplete Params" if !params[:user].present? || !params[:user][:email].present? || !params[:user][:password].present? || !params[:user][:device_id].present? || !params[:user][:device_type].present?
      @user = User.find_by(email: params[:user][:email])
      raise "Email Already Exist" if @user.present?
      @user = User.create!(signup_params)
      user = @user.as_json(except: [:device_id, :device_type, :password])
      payload = { "data": user, exp: expire_time }
      hsh = {}
      hsh[:message] = "Sign-Up Successfully"
      hsh[:token] = JWT.encode payload, hmac_secret, 'HS256'
      hsh[:user] = @user.as_json(except: [:device_id, :device_type, :password])
      render json: hsh.to_json
    rescue Exception => e
      error_handle_bad_request(e)
    end
  end

  def create_profile
    begin
      @current_api_user.update!(create_profile_params)
      hsh = {}
      hsh[:message] = "Profile Updated Successfully"
      hsh[:user] = @current_api_user.as_json(except: [:device_id, :device_type, :password])
      render json: hsh.to_json
    rescue Exception => e
      error_handle_bad_request(e)
    end
  end

  def forgot_password
    begin
      raise "Incomplete Params" if !params[:email].present?
      @user = User.find_by(email: params[:email])
      raise "Email Doesn't Exist" if !@user.present?
      hsh = {}
      hsh[:message] = "Email has been sent to your registered email!"
      render json: hsh.to_json
    rescue Exception => e
      error_handle_bad_request(e)
    end
  end

  # def change_password
  #   begin
  #     raise "Incomplete Params" if !params[:password].present?
  #     @user = User.find_by(email: params[:email])
  #     raise "Email Doesn't Exist" if !@user.present?
  #     hsh = {}
  #     hsh[:message] = "Email has been sent to your registered email!"
  #     render json: hsh.to_json
  #   rescue Exception => e
  #     error_handle_bad_request(e)
  #   end
  # end

  protected

  def signup_params
    params.require(:user).permit(:email, :password, :device_type, :device_id)
  end

  def create_profile_params
    params.require(:user).permit(:first_name, :last_name, :dob, :image, :phone, :country_code, :location, :lat, :lng)
  end

  def hmac_secret
    'my$ecretK3ynasbdgwejh34786&^&^V&3ytgrdcejg((**&^@#&$%^&'
  end

  def expire_time
    Time.now.to_i + 1000 * 3600
  end
end