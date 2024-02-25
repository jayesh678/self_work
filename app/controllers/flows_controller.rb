class FlowsController < ApplicationController
  before_action :set_flow, only: [:edit, :update, :destroy]

  def index
    @flow = Flow.all
    @user_id = params[:user_id]
    @expense_id = params[:expense_id]
    # @flow_id = params[:flow_id]
  end

  # GET /users/:user_id/expenses/:expense_id/flows/new
  def new
    @flow = Flow.new
    @user = User.find(params[:user_id])
    @expense = Expense.find(params[:expense_id])
    @initiator = @expense.flow.user_assigned_id
    @approver = @expense.flow.assigned_user_id
  end

  # POST /users/:user_id/expenses/:expense_id/flows
  def create
    @expense = Expense.find(params[:expense_id])
    @flow = @expense.build_flow(flow_params)

    if @flow.save
      redirect_to user_expense_flows_path, notice: 'Flow was successfully created.'
    else
      render :new
    end
  end

  # GET /users/:user_id/expenses/:expense_id/flows/:id/edit
# app/controllers/flows_controller.rb

def edit
  @user = User.find(params[:user_id])
  @expense = Expense.find(params[:expense_id])
  @flow = Flow.find(params[:id])
  @user_assigned_name = User.find(@flow.user_assigned_id).firstname
  @assigned_user_name = User.find(@flow.assigned_user_id).firstname
end


  # PATCH/PUT /users/:user_id/expenses/:expense_id/flows/:id
  def update
    if @flow.update(flow_params)
      redirect_to user_expense_flows_path, notice: 'Flow was successfully updated.'
    else
      render :edit
    end
  end

  def show 
    @flow = Flow.find(params[:id])
    @user_assigned_name = User.find(@flow.user_assigned_id).firstname
  @assigned_user_name = User.find(@flow.assigned_user_id).firstname
  end

  # DELETE /users/:user_id/expenses/:expense_id/flows/:id
  def destroy
    @flow.destroy
    redirect_to user_expense_flows_path, notice: 'Flow was successfully destroyed.'
  end

  private

  def set_flow
    @flow = Flow.find(params[:id])
  end

  def flow_params
    params.require(:flow).permit(:user_assigned_id, :assigned_user_id, :start_date, :end_date)
  end
end
