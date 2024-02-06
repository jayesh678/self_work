class User < ApplicationRecord
  has_one_attached :avatar
  belongs_to :company
  belongs_to :role
  has_many :expenses
  attr_accessor :company_code


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
end
