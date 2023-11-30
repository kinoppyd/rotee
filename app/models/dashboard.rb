class Dashboard < ApplicationRecord
  has_many :lists, dependent: :destroy
end
