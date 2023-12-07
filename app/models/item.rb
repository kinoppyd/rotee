class Item < ApplicationRecord
  include UuidPrimaryKey

  belongs_to :list

  validates :name, presence: true
  validates :list_id, presence: true
  validates :position, presence: true
end
