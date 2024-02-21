class Flow < ApplicationRecord
  #    belongs_to :initiator, class_name: 'User'
  # belongs_to :approver, class_name: 'User'
  has_many :expenses, dependent: :destroy
  
  attribute :assigned_user_id, :integer

    def self.create_default_flow
        # Implement your logic to create a new default flow
        # For example:
        Flow.create(default: true)
      end

  end