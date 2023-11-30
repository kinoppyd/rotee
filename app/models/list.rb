class List < ApplicationRecord
  belongs_to :dashboard
  has_many :items, -> { order(position: :asc) }, dependent: :destroy

  validates :title, presence: true, length: { maximum: 50 }
  validates :body, length: { maximum: 100 }
  validates :pointer, presence: true
  validates :cycle, presence: true
  validates :next_trigger_at, presence: true
  validates :dashboard_id, presence: true

  attribute :pointer, :integer, default: 0

  enum :cycle, { daily: 0, weekly: 1 }

  before_validation :set_default_trigger
  before_update :set_updated_trigger

  private

  def set_default_trigger
    return if next_trigger_at_changed?

    self.next_trigger_at ||= next_trigger
  end

  def set_updated_trigger
    return if self.next_trigger_at_changed?

    self.next_trigger_at = next_trigger
  end

  def next_trigger
    today = Time.zone.today
    if daily?
      today = today.next_day.to_datetime
    else
      today = today.next_day until today.sunday?
    end
    today
  end
end
