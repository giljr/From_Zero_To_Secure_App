class PasswordResetsController < ApplicationController
  before_action :set_user_by_token, only: [:edit, :update]

  def new
    # Render the password reset form
  end

  def create
    if (user = User.find_by(email: params[:email]))
        PasswordMailer.with(
            user: user,
            token: user.generate_token_for(:password_reset) 
        ).password_reset.deliver_later
    end

    redirect_to root_path, notice: "If your email is in our system, you will receive a password reset link shortly."
  end

  def edit
    # Render the edit password form
  end

  def update
    if @user.update(password_params)
        redirect_to new_session_path, notice: "Password updated successfully. Please log in."
    else    
        # We don't need flash messages here because the form already displays the error messages directly
        render :edit, status: :unprocessable_entity
    end
  end

  private


    def password_params
      params.expect(user: [:password, :password_confirmation])
      # params.require(:user).permit(:password, :password_confirmation)
    end
 

    def set_user_by_token
      @user = User.find_by_token_for(:password_reset, params[:token])
      redirect_to new_password_reset_path, alert: "Invalid or expired token. Please try again!" unless @user.present?
    end
end
