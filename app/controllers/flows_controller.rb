class FlowsController < ApplicationController
    def index
        @flows = Flow.all
    end

    def new
        @flow = Flow.new
    end

    def create
        @flow = Flow.new(flow_params)
        if @flow.save
            redirect_to
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        @flow = Flow.find(params[:id])

    def show
        @flow = Flow.find(params[:id])
    end
    
    def update
        @flow = Flow.new(@user_params)
        if @flow.update
            redirect_to
        else
            render 'edit'
        end
end
end
