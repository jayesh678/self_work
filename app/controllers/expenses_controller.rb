class ExpensesController < ApplicationController
  before_action :find_user, except: [:index]
  before_action :load_categories, only: [:new, :create]
  before_action :set_subcategories, only: [:new, :create]
  before_action :set_business_partners, only: [:new, :create]

  def index
    if current_user.super_admin?
      @expenses = Expense.includes(:user).all
    elsif current_user.admin?
      @expenses = Expense.includes(:user).where.not(user_id: User.where(role: Role.find_by(role_name: 'super_admin')).pluck(:id))
    else
      @expenses = current_user.expenses
    end
    @expenses = @expenses.paginate(page: params[:page], per_page: 2)
  end
  
  def create
    @expense = @user.expenses.new(expense_params)

    if @expense.save
      redirect_to user_expense_path(@user, @expense), notice: 'Expense was successfully created.'
    else
      render :new
    end
  end

  def show
    @expense = @user.expenses.find(params[:id])
  end

  def new
    @expense = Expense.new
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end

  def set_business_partners
    @business_partners = BusinessPartner.all
  end

  def load_categories
    @categories = Category.all
  end

  def set_subcategories
    @regular_subcategories = Category.find_by(name: 'Regular')&.subcategories || []
    @regular_subcategories = JSON.parse(@regular_subcategories).map(&:to_s) if @regular_subcategories.present?
    
    travel_category = Category.find_by(category_type: 'Travel Expense')
    @travel_subcategories = travel_category&.subcategories || []
    @travel_subcategories = JSON.parse(@travel_subcategories).map { |subcategory| OpenStruct.new(name: subcategory) } if @travel_subcategories.present?
  end

  def expense_params
    params.require(:expense).permit(:date_of_application, :expense_date, :category_id, :business_partner_id, :amount, :tax_amount, :receipt, :description, :subcategory, :start_date, :end_date, :application_number)
  end
end
