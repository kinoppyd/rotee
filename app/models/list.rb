class List < ApplicationRecord
  has_many :items, -> { order(position: :asc) }, dependent: :destroy

  validates :title, presence: true, length: { maximum: 50 }
  validates :body, length: { maximum: 100 }
  validates :pointer, presence: true
  validates :cycle, presence: true
  validates :next_trigger_at, presence: true

  attribute :pointer, :integer, default: 0

  enum :cycle, { daily: 0, weekly: 1 }

  before_validation :set_default_trigger

  private

  def set_default_trigger
    self.next_trigger_at ||= Time.current + (daily? ? 1.day : 1.week)
  end
end
