class Flow < ApplicationRecord
    has_many :expenses

    def self.create_default_flow
        # Implement your logic to create a new default flow
        # For example:
        Flow.create(default: true)
      end

  end