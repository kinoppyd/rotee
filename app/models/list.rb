class List < ApplicationRecord
  include UuidPrimaryKey

  belongs_to :dashboard
  has_many :items, -> { order(position: :asc) }, dependent: :destroy
  has_one :timer, dependent: :destroy

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

  def max_pointer
    items.size
  end

  def tick!(current = Time.current)
    return if current < next_trigger_at

    pointer_candidate = next_pointer(current)
    self.pointer = max_pointer <= pointer_candidate ? pointer_candidate - max_pointer : pointer_candidate

    self.next_trigger_at += (daily? ? 24.hours : (7 * 24).hours) while next_trigger_at >= current
    save!
  end

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

  def next_pointer(current)
    return 0 if max_pointer.zero?

    pointer + if current - next_trigger_at > threshold
                ((current - next_trigger_at) / threshold).to_i % items.size
              else
                1
              end
  end

  def threshold
    @threshold ||= daily? ? 24 * 60 * 60 : 24 * 60 * 60 * 7
  end
end
