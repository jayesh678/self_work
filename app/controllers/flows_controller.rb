class FlowsController < ApplicationController
  # GET /flows/new
  def new
    @flow = Flow.new
  end

  # POST /flows
  def create
    @flow = Flow.new(flow_params)

    if @flow.save
      redirect_to @flow, notice: 'Flow was successfully created.'
    else
      render :new
    end
  end

  # GET /flows/:id
  def show
    @flow = Flow.find(params[:id])
  end

  private

  # Only allow a list of trusted parameters through.
  def flow_params
    params.require(:flow).permit(:user_assigned_id, :assigned_user_id, :start_date, :end_date)
  end