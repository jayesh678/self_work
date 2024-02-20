class Expense < ApplicationRecord
  # original
  belongs_to :user
  belongs_to :flow, optional: true
  belongs_to :initiator, class_name: 'User', foreign_key: 'initiator_id', optional: true
  belongs_to :approver, class_name: 'User', foreign_key: 'approver_id', optional: true
  belongs_to :business_partner
  belongs_to :category
  has_one_attached :receipt
  before_create :generate_application_number
  before_create :assign_approver_for_initiated_expense

  enum status: { ideal: 0, initiated: 1, approved: 2, canceled: 3 }

  validates :application_number, uniqueness: true
  validates :date_of_application, presence: true
  validates :expense_date, presence: true
  validates :category, presence: true
  validates :business_partner, presence: true
  validates :amount, presence: true
  validates :tax_amount, presence: true
  validates :description, presence: true
  validates :receipt, presence: true
  validates_presence_of :start_date, :end_date, if: :travel_expense
  validate :end_date_is_after_start_date, if: -> { travel_expense && start_date.present? && end_date.present? }

  def travel_expense
    category_id == Category.find_by(name: "travel_expense")&.id
  end

  private

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
 
  def assign_approver_for_initiated_expense
    self.approver_id = 4 if status == 'initiated'
  end

  def end_date_is_after_start_date
    errors.add(:end_date, "cannot be before the start date") if end_date < start_date
  end
end