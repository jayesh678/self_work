class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :business_partner
  belongs_to :category
  belongs_to :flow
  has_one_attached :receipt

  before_create :generate_application_number
  before_validation :set_default_values, on: :create

  enum status: { initiated: 0, approved: 1, canceled: 2 }

 enum status: {ideal: 0, initiated: 1, approved:2, cancel:3 }

  validates :application_number, uniqueness: true
  validates :date_of_application, presence: true
  validates :expense_date, presence: true
  validates :category, presence: true
  validates :business_partner, presence: true
  validates :amount, presence: true
  validates :tax_amount, presence: true
  validates :description, presence: true
  validates :receipt, presence: true
  validates_presence_of :start_date, :end_date,:if => :travel_expense
  validate :end_date_is_after_start_date, :if => :travel_expense

  def travel_expense
    category_id == Category.find_by(name: "travel_expense")&.id
  end

  def create_initiator_flow(initiator_id)
    # Find or create the default flow for the initiator
    default_flow = Flow.find_or_create_by(default: true)
    
    # Define predefined approvers
    approver_ids = [4, 5] # IDs of predefined approvers
    
    # Update the initiator's flow with predefined approvers
    default_flow.update(user_assigned_id: initiator_id, assigned_user_id: approver_ids, flow_levels: 'initiator_and_approvers')
    
    # Debug output
    puts "Initiator flow created with assigned users: #{default_flow.assigned_user_id}"
  end
  

  private

  def set_default_values
    # Assign the current user as the initiator
    self.user ||= User.current_user if User.current_user  # Assuming you have a way to access the current user
    # Set the status to initiated
    self.status ||= :initiated
    # Find or create the default flow and associate it with the expense
    self.flow ||= find_or_create_default_flow
  end

  def find_or_create_default_flow
    # Check if a default flow already exists
    default_flow = Flow.find_by(default: true)

    # If default flow exists, return it
    return default_flow if default_flow.present?

    # Otherwise, create a new default flow
    new_default_flow = Flow.create_default_flow
    return new_default_flow
  end

  def generate_application_number
    category_prefix = category_prefix_for_application_number
    last_application_number = Expense.where(category_id: category_id).maximum(:application_number).to_i
    new_application_number = last_application_number + 1
    loop do
      candidate_application_number = "#{category_prefix}#{new_application_number}"
      unless Expense.exists?(application_number: candidate_application_number)
        self.application_number = candidate_application_number
        break
      end
      new_application_number += 1
    end
  end

  def category_prefix_for_application_number
    category_id == 1 ? 'E-' : 'T-'
  end

  def end_date_is_after_start_date
    errors.add(:end_date, "cannot be before the start date") if end_date < start_date
  end
end
