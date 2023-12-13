class Dashboard < ApplicationRecord
  include UuidPrimaryKey

  has_many :lists, dependent: :destroy
  validates :title, presence: true
end
