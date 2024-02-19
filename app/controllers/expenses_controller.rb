class ExpensesController < ApplicationController
  before_action :find_user
  before_action :load_categories, only: [:new, :create]
  before_action :set_subcategories, only: [:new, :create]
  before_action :set_business_partners, only: [:new, :create]
  before_action :find_expense, only: [:edit, :update, :destroy]

  def index
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
    @expense = @user.expenses.new(expense_params)
    
    if params[:save_button]  
      if @expense.save(validate: false)  
        redirect_to user_expense_path(@user, @expense), notice: 'Expense was saved.'
      else
        render :new
      end
    else 
      if @expense.save
        if current_user.approver?  
          redirect_to approve_expense_path(@user, @expense) 
        else
          @expense.update(status: :initiated)  
          create_initiator_flow(current_user.id)  
          redirect_to user_expense_path(@user, @expense), notice: 'Expense was successfully created.'
        end
      else
        render :new
      end
    end
  end
  
  

  def show
    @user = User.find(params[:user_id])
    @expense = @user.expenses.find(params[:id])
  end

  def new
    @expense = Expense.new
  end

  def edit
    @user = User.find(params[:user_id])
    @expense = @user.expenses.find(params[:id])
    @categories = Category.all
    @subcategories = Category.pluck(:subcategories).flatten.uniq
  end

  def update
    if @expense.update(expense_params)
      redirect_to user_expense_path(@user, @expense), notice: 'Expense was successfully updated.'
    else
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
    @regular_subcategories = Category.find_by(name: 'Regular')&.subcategories || []
    @regular_subcategories = JSON.parse(@regular_subcategories).map(&:to_s) if @regular_subcategories.present?
  
    travel_category = Category.find_by(category_type: 'Travel Expense')
    @travel_subcategories = travel_category&.subcategories || []
    @travel_subcategories = JSON.parse(@travel_subcategories).map { |subcategory| OpenStruct.new(name: subcategory) } if @travel_subcategories.present?
  end

  def find_expense
    @expense = @user.expenses.find(params[:id])
  end

  def create_initiator_flow(initiator_id)
    approvers_ids = [2, 3]  
    initiator_flow = Flow.find_or_create_by(user_assigned_id: initiator_id)
    initiator_flow.update(assigned_user_id: approvers_ids, flow_levels: 'initiator_and_approvers')
  end

  def expense_params
    params.require(:expense).permit(:date_of_application, :expense_date, :category_id, :business_partner_id, :amount, :tax_amount, :receipt, :description, :subcategory, :start_date, :end_date, :application_number, :source, :destination)
  end
end