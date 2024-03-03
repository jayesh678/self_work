class Flow < ApplicationRecord
  #    belongs_to :initiator, class_name: 'User'
  # belongs_to :approver, class_name: 'User'
  belongs_to :expense
  has_and_belongs_to_many :assigned_users, class_name: 'User'
  # serialize :assigned_user_ids, Array, coder: JSON
  
  # attribute :assigned_user_id, :integer


  end