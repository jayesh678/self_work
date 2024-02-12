class User < ApplicationRecord
  has_one_attached :avatar
  belongs_to :company
  belongs_to :role
  has_many :expenses, dependent: :destroy
  before_create :generate_uniq_user_code

  validates_presence_of :role, if: :new_record?
  validate :blank_space

  after_create :set_default_role
  attr_accessor :company_code

  validates :firstname, presence: true
  validates :lastname, presence: true

  private 

   def blank_space
    if password&.include?(' ')
    errors.add(:password, "can't contain spaces")
  end
   end

   def generate_uniq_user_code
    self.user_code = SecureRandom.hex(3)
   end

    def set_default_role
      if self.role.nil?
        self.role = Role.find_by(role_name: 'super_admin')
      else 
        self.role.id  
      end
    # save
  end


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
end
