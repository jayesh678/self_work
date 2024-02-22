class ExpenseMailer < ApplicationMailer
    
  def notify_assigned_user(flow_id)
    flow = Flow.find_by(user_assigned_id: flow_id)
    if flow.present? 
      @user = User.find_by(id: flow.assigned_user_id)
      @expense = Expense.all
      if @user.present?
        @expense = Expense.find_by(flow_id: flow.id)
        mail(to: @user.email, subject: 'New Expense Assigned') if @expense.present?
      end
    end
  end
end
