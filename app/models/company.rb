class Company < ApplicationRecord
  has_many :users, dependent: :destroy
  before_create :generate_uniqueid

  private

  def generate_uniqueid
    self.company_uniqueid = SecureRandom.hex(4) 
  end
end
