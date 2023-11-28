class Item < ApplicationRecord
  belongs_to :list
  
  validates :name, presence: true
  validates :list_id, presence: true
end
