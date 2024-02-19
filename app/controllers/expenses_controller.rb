class ExpensesController < ApplicationController
  before_action :find_user, except: [:index, :create]
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
    
    if @expense.save
      if current_user.approver?
        redirect_to approve_expense_path(@user, @expense)
      else
        flow = create_initiator_flow(current_user.id)
        
        if flow.present?
          @expense.update(status: :initiated, flow: flow)
          redirect_to user_expense_path(@user, @expense), notice: 'Expense was successfully created.'
        else
          redirect_to new_user_expense_path(@user), alert: 'Failed to create expense flow.'
        end
      end
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

  def edit
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
    if @expense.destroy
      redirect_to user_expenses_path(user_id: current_user.id), notice: 'Expense was successfully destroyed.'
    else
      redirect_to user_expense_path(user_id: current_user.id, id: @expense.id), alert: 'Failed to destroy expense.'
    end
  end

  def approve
    if current_user.approver?
      @expense.update(status: :approved)
      redirect_to user_expense_path(@user, @expense), notice: 'Expense was successfully approved.'
    else
      redirect_to user_expense_path(@user, @expense), alert: 'You are not authorized to approve expenses.'
    end
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
    @travel_subcategories = Category.find_by(category_type: 'Travel Expense')&.subcategories || []
  end

  def find_expense
    @expense = @user.expenses.find(params[:id])
  end

  def create_initiator_flow(initiator_id)
    # Find or create the default flow for the initiator
    default_flow = Flow.find_or_create_by(default: true)
    # Update the initiator's flow
    default_flow.update(user_assigned_id: initiator_id, assigned_user_id: [2, 3], flow_levels: 'initiator_and_approvers')
  
    # Debug output
    puts "Initiator flow created with assigned users: #{default_flow.assigned_user_id}"
    default_flow
  end
  
  def expense_params
    params.require(:expense).permit(:date_of_application, :expense_date, :category_id, :business_partner_id, :amount, :tax_amount, :receipt, :description, :subcategory, :start_date, :end_date, :application_number)
  end
end
