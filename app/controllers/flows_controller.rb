class FlowsController < ApplicationController
  before_action :set_expense
  before_action :set_flow, only: [:edit, :update, :show, :destroy]

  # GET /users/:user_id/expenses/:expense_id/flows
  def index
    @flows = @expense.flows
    @user_id = params[:user_id]
    @expense_id = params[:expense_id]
    # @approvers = @flow.assigned_user_ids
  end


  # GET /users/:user_id/expenses/:expense_id/flows/new
  def new
    @flow = @expense.flows.new
  end

  # POST /users/:user_id/expenses/:expense_id/flows
  def create
    @flow = @expense.flows.new(flow_params)

    if @flow.save
      redirect_to user_expense_flows_path, notice: 'Flow was successfully created.'
    else
      render :new
    end
  end

  # GET /users/:user_id/expenses/:expense_id/flows/:id/edit
  def edit
    @user = User.find(params[:user_id])
    @approvers = @flow.assigned_user_ids
  end

  def show 
    @approvers = @flow.assigned_user_ids
  end

  # PATCH/PUT /users/:user_id/expenses/:expense_id/flows/:id
  def update
    if @flow.update(flow_params)
      redirect_to user_expense_flows_path, notice: 'Flow was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/:user_id/expenses/:expense_id/flows/:id
  def destroy
    @flow.destroy
    redirect_to user_expense_flows_path, notice: 'Flow was successfully destroyed.'
  end

  private

  def set_expense
    @expense = Expense.find(params[:expense_id])
  end

  def set_flow
    @flow = @expense.flows.find(params[:id])
  end

  def flow_params
    params.require(:flow).permit(:user_assigned_id, :assigned_user_ids, :start_date, :end_date)
  end
end
