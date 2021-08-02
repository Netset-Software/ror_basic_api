class Api::V1::ApplicationController < ActionController::API

  before_action :authenticate_api_user

  def authenticate_api_user
    @current_api_user
    begin
      if request.headers["HTTP_AUTHORIZATION"].present?
        token = request.headers["HTTP_AUTHORIZATION"]
        decoded_token = JWT.decode token, hmac_secret, true, { algorithm: 'HS256' }
        raise "Seems you are logout" if !decoded_token[0]["data"]["email"].present?
        @current_api_user = User.find_by(email: decoded_token[0]["data"]["email"], is_delete: false, status: 0)
      end
      raise "Seems you are logout" if @current_api_user.nil?
    rescue Exception => @e
        err_hash = HashWithIndifferentAccess.new
        err_hash[:error] = @e.message
        render json: err_hash.to_json, status: :unauthorized
    end
  end

  def jwt_token(payload)
    JWT.encode payload, hmac_secret, 'HS256'
  end

  def error_handle_bad_request(e)
    ary_errors = []
    ary_errors_obj = {}
    ary_errors_obj[:domain] = "usageLimits"
    ary_errors_obj[:reason] = e.message
    ary_errors_obj[:message] = e.message.humanize
    ary_errors_obj[:extendedHelp] = ""
    ary_errors.push(ary_errors_obj)
    error_obj = {}
    error_obj[:errors] = ary_errors
    error_obj[:code] = 400
    error_obj[:message] = e.message.humanize
    error_obj[:reason] = e.message
    err_hash = {}
    err_hash[:error] = error_obj
    render :json => err_hash.to_json, status: :bad_request
  end

  protected

  def hmac_secret
    'my$ecretK3ynasbdgwejh34786&^&^V&3ytgrdcejg((**&^@#&$%^&'
  end

end
