class ExpensesController < ApplicationController
  before_action :find_user
  before_action :load_categories, only: [:new, :create]
  before_action :set_subcategories, only: [:new, :create]
  before_action :set_business_partners, only: [:new, :create]

  def index
    @user = current_user
    @expenses = @user.expenses
  end

  def create
    @expense = @user.expenses.new(expense_params)

    if @expense.save
      redirect_to user_expenses_path(@user, @expense), notice: 'Expense was successfully created.'
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:user_id])
    @expense = @user.expenses.find(params[:id])
  end

  def new
    @expense = Expense.new
  end

  def subcategories
    category = Category.find(params[:category_id])
    subcategories = category.subcategories || []
    
    response = {}
    if category.category_type == 'Regular'
      response[:regular_subcategories] = subcategories
    elsif category.category_type == 'Travel Expense'
      response[:travel_subcategories] = subcategories
    end
    
    render json: response
  end

  private

  def find_user
    @user = User.find(params[:user_id]) if params[:user_id].present?
  end

  def set_business_partners
    @business_partners = BusinessPartner.all
  end

  def load_categories
    @categories = Category.all
  end

  def set_subcategories
    @regular_subcategories = Category.find_by(category_type: 'Regular')&.subcategories&.split(',') || []
    @travel_subcategories = Category.find_by(category_type: 'Travel Expense')&.subcategories&.split(',') || []
  end
  
  

  def expense_params
    params.require(:expense).permit(:date_of_application, :expense_date, :category_id, :business_partner_id, :amount, :tax_amount, :receipt, :description, :subcategory, :start_date, :end_date, :application_number)
  end
end
