class Dashboard < ApplicationRecord
  include UuidPrimaryKey

  has_many :lists, dependent: :destroy
end
