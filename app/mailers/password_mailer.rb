class PasswordMailer < ApplicationMailer
    def password_reset
        mail(to: params[:user].email, subject: "Your Password Has Been Changed")
        # mail to: params[:user].email
    end
end
