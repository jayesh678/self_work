class UsersController < ApplicationController
    before_action :set_user, only: [:show,:edit, :update, :destroy]
    load_and_authorize_resource
     
    
  def index
    @user = User.all
    @user = current_user
     current_company = current_user.company
      @users = current_company.users
  end

  def show
    if params[:id]
      @user = User.find(params[:id])
    else
      @user = current_user
    end
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
      redirect_to user_path, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end
    
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
     respond_to do |format|
      format.html { redirect_to users_path, notice: 'page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
    
  
  private

  def set_user
    @user = User.find_by(id: params[:id])
  end

  def user_params
    if action_name == "create"
  	params.require(:user).permit(:firstname, :lastname, :email, :password, :password_confirmation, :avatar, :role_id, :company_id)
    else
      action_name == "update"
        params.require(:user).permit(:firstname, :lastname)
    end
	end
end
  