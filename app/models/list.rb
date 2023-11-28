class List < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }
  validates :body, length: { maximum: 100 }
  validates :pointer, presence: true
  validates :cycle, presence: true
  validates :next_trigger_at, presence: true

  enum :cycle, { daily: 0, weekly: 1 }
end
