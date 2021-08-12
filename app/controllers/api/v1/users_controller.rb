class Api::V1::UsersController < Api::V1::ApplicationController

  before_action :authenticate_api_user, except: [:sign_in, :sign_up, :forgot_password, :reset_password]

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
      hsh[:token] = jwt_token payload
      hsh[:user] = user
      render json: hsh.to_json
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
      user = @user.user_obj
      payload = { "data": user, exp: expire_time }
      hsh = {}
      hsh[:message] = "Sign-Up Successfully"
      hsh[:token] = jwt_token payload
      hsh[:user] = user
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
      hsh[:user] = @current_api_user.user_obj
      render json: hsh.to_json
    rescue Exception => e
      error_handle_bad_request(e)
    end
  end

  def forgot_password
    begin
      raise "Email not present" unless params[:email].present?
      @user = User.find_by(email: params[:email])
      raise "Email address not found. Please check and try again." unless @user.present?
      @user.generate_password_token!
      ResetPasswordMailer.send_reset_password_email(@user).deliver_now
      render json: {status: 'An email has been sent with a link to reset your password.'}, status: :ok
    rescue Exception => e
      error_handle_bad_request(e)
    end
  end

  def reset_password
    begin
      token = params[:token].to_s
      raise "Token not present" if params[:token].present?
      user = User.find_by(reset_password_token: token)
      if user.present? && user.password_token_valid?
        user.reset_password!(params[:password])
        render json: {status: 'Password reset successfully'}, status: :ok
      else
        render json: {error: 'Link not valid or expired. Try generating a new link.'}, status: :not_found
      end
    rescue Exception => e
      error_handle_bad_request(e)
    end
  end

  def change_password
    begin
      raise "Incomplete params"  unless params[:new_password].present? || params[:old_password].present?
      raise "Old Password is invalid" if @current_api_user.valid_password?(params[:old_password])
      raise "New Password should not be the same as Old Password." if (params[:new_password] == params[:old_password])
      @current_api_user.update!(password: params[:new_password])
      render json: {status: 'Password updated successfully'}, status: :ok
    rescue Exception => e
      error_handle_bad_request(e)
    end
  end

  protected

  def signup_params
    params.require(:user).permit(:email, :password, :device_type, :device_id)
  end

  def create_profile_params
    params.require(:user).permit(:first_name, :last_name, :dob, :image, :phone, :country_code, :location, :lat, :lng)
  end

  def expire_time
    Time.now.to_i + 1000 * 3600
  end
end