class RegistrationsController < ApplicationController

    def index
        @users = User.all
    end

    def show
        @user = User.find(params[:id])
    end

  
    def new
        @user = User.new
    end

    def create
        @user = User.new(registration_params)
        if @user.save
            login @user
            redirect_to root_path, notice: 'Account created successfully.'
        else    
            render :new, status: :unprocessable_entity
        end
    end

    private


    def registration_params
        params.expect(user: [:email, :password, :password_confirmation])
    end
end