class User < ApplicationRecord
  has_one_attached :avatar
  belongs_to :company
  belongs_to :role
  has_many :expenses, dependent: :destroy
  attr_accessor :company_code

  validates :firstname, presence: true
  validates :lastname, presence: true


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
end
