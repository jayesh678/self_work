class User < ApplicationRecord
  has_one_attached :avatar
  belongs_to :company
  belongs_to :role
  has_many :expenses, dependent: :destroy
  # has_many :initiated_flows, class_name: 'Flow', foreign_key: 'initiator_id'
  # has_many :approved_flows, class_name: 'Flow', foreign_key: 'approver_id'
  before_validation :generate_unique_code, on: :create

  validates :user_code, uniqueness: true
  validates_presence_of :role, if: :new_record?
  validate :blank_space
  after_create :set_default_role
  attr_accessor :company_code
  validates :firstname, presence: true
  validates :lastname, presence: true

  def super_admin?
    role.role_name == 'super_admin'
  end
  
  def admin?
    role.role_name == 'admin'
  end
  
  def user?
    role.role_name == 'user'
  end

  def approver?
    Flow.exists?(assigned_user_id: id)
  end
  

  private 

  def blank_space
    if password&.include?(' ')
    errors.add(:password, "can't contain spaces")
  end
  end

  def generate_unique_code
    loop do
      self.user_code = SecureRandom.hex(6) 
      break unless self.class.exists?(user_code: user_code)
    end
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