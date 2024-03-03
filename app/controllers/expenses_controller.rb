class ExpensesController < ApplicationController
  
    rescue_from CanCan::AccessDenied do |exception|
      render "shared/access_denied", status: :forbidden
    end
  load_and_authorize_resource
  # Main
  # before_action :set_expense, only: [:index]
  before_action :find_user
  before_action :load_categories, only: [:new, :create, :update]
  before_action :set_subcategories, only: [:new, :create, :update]
  before_action :set_business_partners, only: [:new, :create, :update]
  before_action :find_expense, only: [:edit, :update, :destroy]

  def index
    if current_user.super_admin?
      @expenses = Expense.includes(:user).where(users: { company_id: current_user.company_id })
    elsif current_user.admin?
      @expenses = Expense.includes(:user).where(user_id: current_user.company.users.where.not(role_id: Role.find_by(role_name: 'super_admin').id))
    else
      @expenses = current_user.expenses
    end
    @expenses = @expenses.paginate(page: params[:page], per_page: 5)
    
    # @expense = Expense.find(params[:expense_id]) if params[:expense_id]
  end
  
 
  def create
    @subcategories = Subcategory.all
    @expense = current_user.expenses.new(expense_params)
    @expense.status = "initiated"
    
    if @expense.save
      approvers = User.joins(:role).where(roles: { role_name: ['admin', 'super_admin'] })
      
      # Create or find the flow associated with this expense
      flow = Flow.includes(:assigned_users).find_or_create_by(expense_id: @expense.id, user_assigned_id: current_user.id)
  
      # Set the assigned_user_ids for the flow
      flow.assigned_user_ids = approvers.pluck(:id)
  
      # Save the flow
      if flow.save
        # Check for validation errors
        if flow.errors.any?
          puts flow.errors.full_messages
        end
        
        # Optionally, you can check if flow is present and notify assigned user
        if flow.present? && flow.assigned_user_ids.present?
          ExpenseMailer.notify_assigned_user(flow.id).deliver_now
        end
        
        # Verify association setup
        puts flow.assigned_user_ids.inspect
        
        redirect_to user_expenses_path, notice: 'Expense was successfully created.'
      else
        render :new
      end
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
    @expense.flows.build # Initialize a new flow associated with the expense
    @flows = @expense.flows # Fetch the flows associated with the expense
  end
  
  
  

  def edit
    @user = User.find(params[:user_id])
    @expense = @user.expenses.find(params[:id])
    
    # Find the flow associated with the expense
    @flows = @expense.flows
    
    @categories = Category.all
    @regular_subcategories = Category.find_by(category_type: 'Regular')&.subcategories
    @travel_subcategories = Category.find_by(category_type: 'Travel')&.subcategories
    @business_partners = BusinessPartner.all
    @subcategories = Subcategory.all
  end
  

  def update
    @expense = Expense.find(params[:id])
    @flow = Flow.find_by(user_assigned_id: @expense.user_id)
    approvers = @flow.assigned_user_ids
    
    if current_user.id.in?(approvers)
      if params[:approve_button]
        update_status_and_redirect(:approved, 'Expense was successfully approved.')
        ExpenseMailer.notify_super_admin(@expense).deliver_now
      elsif params[:cancel_button]
        update_status_and_redirect(:cancelled, 'Expense was successfully cancelled.')
      else
        update_expense('Expense was successfully updated')
      end
    else
      update_expense('Expense was successfully updated')  
    end
  end
  
  


  def approve
    @expense = Expense.find(params[:id])
    if @expense.update(status: :approved)
      redirect_to user_expenses_path, notice: 'Expense approved successfully.'
    else
      redirect_to user_expenses_path, alert: 'Failed to approve expense.'
    end
  end

  def cancel
    @expense = Expense.find(params[:id])
    if @expense.update(status: :cancelled)
      redirect_to user_expenses_path, notice: 'Expense cancelled successfully.'
    else
      redirect_to user_expenses_path, alert: 'Failed to cancel expense.'
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

  def user_assigned_id
    Flow.pluck(:user_assigned_id)
  end

  def assigned_user_id
    Flow.pluck(:assigned_user_id)
  end


  def update_expense(success_message = 'Expense was successfully updated')
    if @expense.update(expense_params)
      flash[:notice] = success_message
      redirect_to user_expenses_path(current_user)
    else
      render :edit
    end
  end

def update_status_and_redirect(status, notice_message)
  if @expense.update(status: status)
    redirect_to user_expenses_path(current_user), notice: notice_message
  else
    flash.now[:alert] = "Failed to update expense."
    render :edit
  end
end


def set_expense
  @expense = Expense.find(params[:expense_id]) if params[:expense_id]
end

  def expense_params
    params.require(:expense).permit(:number_of_people ,:application_name, :total_amount, :date_of_application, :subcategory_id, :expense_date, :category_id,:start_date, :end_date, :source, :destination, :business_partner_id, :amount, :tax_amount, :status, :receipt, :description, :application_number)
  end
end