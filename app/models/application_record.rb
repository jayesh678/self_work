class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  require "active_storage/engine"
end
