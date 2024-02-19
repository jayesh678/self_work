class ExpensesController < ApplicationController
  # Main
  before_action :find_user
  before_action :load_categories, only: [:new, :create]
  before_action :set_subcategories, only: [:new, :create]
  before_action :set_business_partners, only: [:new, :create]
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
  @expense.status = "initiated"
   @expense.initiator_id = current_user.id
  
  if @expense.save
    # Assigning the current user as the initiator of the expense
    @expense.update(initiator_id: current_user.id)
    redirect_to user_expenses_path , notice: 'Expense was successfully created.'
  else
    render :new
  end
end

  
  def show
    # Finding the user and expense for the show page
    @user = User.find(params[:user_id])
    @expense = @user.expenses.find(params[:id])
  end

  def new
    # Creating a new expense object
    @expense = Expense.new
  end

  def edit
    # Finding the user and expense for editing
    @user = User.find(params[:user_id])
    @expense = @user.expenses.find(params[:id])
    @categories = Category.all
    @subcategories = Category.pluck(:subcategories).flatten.uniq
  end

  def update
    # Updating the expense
    if @expense.update(expense_params)
      redirect_to user_expense_path(@user, @expense), notice: 'Expense was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    # Destroying the expense
    @expense = Expense.find(params[:id])
    if @expense.destroy
      redirect_to user_expenses_path(user_id: current_user.id), notice: 'Expense was successfully destroyed.'
    else
      redirect_to user_expense_path(user_id: current_user.id, id: @expense.id), alert: 'Failed to destroy expense.'
    end
  end

  private

  def find_user
    # Finding the user if user_id parameter is present
    if params[:user_id]
      @user = User.find(params[:user_id])
    end
  end

  def set_business_partners
    # Setting business partners
    @business_partners = BusinessPartner.all
  end

  def load_categories
    # Loading categories
    @categories = Category.all
  end

  def set_subcategories
    # Setting subcategories
    @regular_subcategories = Category.find_by(name: 'Regular')&.subcategories || []
    @travel_subcategories = Category.find_by(category_type: 'Travel Expense')&.subcategories || []
  end

  def find_expense
    # Finding the expense for edit, update, and destroy actions
    @expense = @user.expenses.find(params[:id])
  end

  def expense_params
    # Strong parameters for expense creation and update
    params.require(:expense).permit(:date_of_application, :expense_date, :category_id, :business_partner_id, :amount, :tax_amount, :receipt, :description, :subcategory, :start_date, :end_date, :application_number)
  end
end
