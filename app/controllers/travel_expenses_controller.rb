class TravelExpensesController < ApplicationController
    before_action :set_travel_expense, only: %i[show edit update destroy]
  
    def index
      @travel_expenses = TravelExpense.all
    end
  
    def show
    end
  
    def new
        @travel_expense = TravelExpense.new
        @categories = Category.all
      end
    
      def create
        @travel_expense = TravelExpense.new(travel_expense_params)
        if @travel_expense.save
          redirect_to @travel_expense, notice: 'Travel Expense was successfully created.'
        else
          render :new
        end
      end
  
    def edit
    end
  
    def update
      if @travel_expense.update(travel_expense_params)
        redirect_to @travel_expense, notice: 'Travel Expense was successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy
      @travel_expense.destroy
      redirect_to travel_expenses_url, notice: 'Travel Expense was successfully destroyed.'
    end
  
    private
  
    def set_travel_expense
      @travel_expense = TravelExpense.find(params[:id])
    end
  
    def travel_expense_params
        params.require(:travel_expense).permit(:amount, :tax_amount, :application_number, :description, :date, :number_of_people, :expense_date, :receipt,:user_id, :business_partner_id, :category_id)
      end
      
  