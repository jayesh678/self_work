class FlowsController < ApplicationController
  before_action :authenticate_user! 
  
  def index
    @flows = Flow.all
  end

  def new
    @flow = Flow.new
  end

  def create
    @flow = Flow.new(flow_params)

    if @flow.save
      redirect_to @flow, notice: 'Flow was successfully created.'
    else
      render :new
    end
  end

  def show
    @flow = Flow.find(params[:id])
  end

  private
  def flow_params
    params.require(:flow).permit(:user_assigned_id, :assigned_user_id, :start_date, :end_date)
  end
end