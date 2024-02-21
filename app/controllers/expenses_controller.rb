class ExpensesController < ApplicationController
  # Main
  before_action :find_user
  before_action :load_categories, only: [:new, :create]
  before_action :set_subcategories, only: [:new, :create, :update]
  before_action :set_business_partners, only: [:new, :create, :update]
  before_action :find_expense, only: [:edit, :update, :destroy]

  def index
    # Logic for displaying expenses based on user roles
    if current_user.super_admin?
      @expenses = Expense.includes(:user).all
    elsif current_user.admin?
      @expenses = Expense.includes(:user).where.not(user_id: User.where(role: Role.find_by(role_name: 'super_admin')).pluck(:id))
    else
      @user = current_user
      @expenses = current_user.expenses
    end
    @expenses = @expenses.paginate(page: params[:page], per_page: 2)
  end

 
  def create
  @expense = current_user.expenses.new(expense_params)
  @flow = Flow.find_by(user_assigned_id: user_assigned_ids)
  @expense.status = "initiated"
  @expense.initiator_id = current_user.id
  
  if @expense.save
      flow = Flow.find_or_create_by(user_assigned_id: current_user.id)
  @expense.update(flow_id: flow.id)
    redirect_to user_expenses_path , notice: 'Expense was successfully created.'
  else
    #  flash.now[:error] = @expense.errors.full_messages.join(". ")
    render :new
  end
end
  def show
    @user = User.find(params[:user_id])
    @expense = @user.expenses.find(params[:id])
  end

  def new
    @expense = Expense.new
    @flow = Flow.find_by(user_assigned_id: user_assigned_ids)
  end

  def edit
    @user = User.find(params[:user_id])
    @expense = @user.expenses.find(params[:id])
    @flow = Flow.find_by(user_assigned_id: user_assigned_ids)
    @categories = Category.all
    @regular_subcategories = Category.find_by(category_type: 'Regular')&.subcategories
    @travel_subcategories = Category.find_by(category_type: 'Travel')&.subcategories
    @business_partners = BusinessPartner.all
    @subcategories = Subcategory.all
  end

  def update
    @categories = Category.all
    if @expense.update(expense_params)
      redirect_to user_expense_path(@user, @expense), notice: 'Expense was successfully updated.'
    else
       #  flash.now[:error] = @expense.errors.full_messages
      render :edit
    end
  end

  def destroy
    @expense = Expense.find(params[:id])
    if @expense.destroy
      redirect_to user_expenses_path(user_id: current_user.id), notice: 'Expense was successfully destroyed.'
    else

      redirect_to user_expense_path(user_id: current_user.id, id: @expense.id), alert: 'Failed to destroy expense.'
    end

    # def assigned_user_id
    #   @assigned_user_id = predefined_approver_id
    # end
  end

  private

  def find_user
    if params[:user_id]
      @user = User.find(params[:user_id])
    end
  end

  def set_business_partners
    @business_partners = BusinessPartner.all
  end

  def load_categories
    @categories = Category.all
  end

  def set_subcategories
    @subcategories = Subcategory.all
    @regular_subcategories = Category.find_by(category_type: 'Regular')&.subcategories
    @travel_subcategories = Category.find_by(category_type: 'Travel')&.subcategories
  end

  def find_expense
    @expense = @user.expenses.find(params[:id])
  end

  def user_assigned_ids
    Flow.pluck(:user_assigned_id)
  end

  def assigned_user_id
    Flow.pluck(:assigned_user_id)
  end

  def expense_params
    params.require(:expense).permit(:date_of_application, :subcategory_id, :expense_date, :category_id,:start_date, :end_date, :business_partner_id, :amount, :tax_amount, :receipt, :description, :application_number)
  end
end
