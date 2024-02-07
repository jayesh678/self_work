class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :business_partner
  belongs_to :category
  has_one_attached :receipt
  before_create :generate_application_number

  validates :application_number, uniqueness: true
  validates :date_of_application, presence: true
private
  def generate_application_number
    last_application_number = Expense.maximum(:application_number)
    category_prefix = category_prefix_for_application_number
    self.application_number = "#{category_prefix}#{last_application_number.to_i + 1}"
  end

  def category_prefix_for_application_number
    if category_id == 7
      'E-'
    else 
      'T-'
    end
  end
end
