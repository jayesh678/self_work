class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    # load_and_authorize_resource
  
    def index
     @users = User.all
     @user = current_user
    end
  
    def show
      @user = current_user
      @company = @user.company
    end
  
    def new
      @user = User.new  
    end
  
    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to @user, notice: 'User was successfully created.'
      else
        render :new
      end
    end
  
    def edit
        @user = User.find(params[:id])
    end

    def update
      if @user.update(user_params)
        @user.avatar.attach(params[:user][:avatar]) if params[:user][:avatar]
        redirect_to @user, notice: 'User was successfully updated.'
      else
        render :edit
      end
    end
    
  
    def destroy
      @user = User.find(params[:id])
      @user.destroy
    end
    
  
    private

    def set_user
        @user = User.find_by(id: params[:id])
      end
  
  def user_params
  params.require(:user).permit(:firstname, :lastname, :email, :password, :password_confirmation, :avatar, :role_id, :company_id)
end

  end
  