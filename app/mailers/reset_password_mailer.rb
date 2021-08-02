class ResetPasswordMailer < ApplicationMailer
  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_reset_password_email(user)
    @user = user
    @url = "http://localhost:3000/api/v1/users/reset_password?token=#{@user.reset_password_token}"
    mail( to: @user.email, subject: 'Reset Password Email' )
  end

end
