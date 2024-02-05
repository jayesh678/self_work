class ExpensesController < ApplicationController
  before_action :set_expense, only: %i[show edit update destroy]

  def index
    @expenses = Expense.all
    @user = current_user
  end

  def show
    # Find the expense based on the ID parameter
    @expense = Expense.find(params[:id])
    @user = @expense.user 
  end

  def new
    @user = User.find(params[:user_id]) # Assuming user_id is present in the URL
    @expense = @user.expenses.build
    @categories = Category.all
    @business_partners = BusinessPartner.all
  end

  def create
    @user = User.find(params[:user_id]) # Assuming user_id is present in the URL
    @expense = @user.expenses.build(expense_params)
    
    if @expense.save
      redirect_to user_expense_url(@user, @expense), notice: 'Expense was successfully created.'

    else
      render :new
    end
  end
  def edit
    # Find the expense based on the ID parameter
    @expense = Expense.find(params[:id])
    @categories = Category.all
    @business_partners = BusinessPartner.all
  end

  def update
    if @expense.update(expense_params)
      redirect_to @expense, notice: 'Expense was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @expense.destroy
    redirect_to expenses_url, notice: 'Expense was successfully destroyed.'
  end

  private

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:amount, :tax_amount, :application_number, :description, :date, :number_of_people, :expense_date, :receipt, :status, :user_id, :business_partner_id, :category_id)
  end
end
