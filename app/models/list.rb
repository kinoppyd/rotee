class List < ApplicationRecord
  include UuidPrimaryKey

  belongs_to :dashboard
  has_many :items, -> { order(position: :asc) }, dependent: :destroy
  has_one :timer, dependent: :destroy

  validates :title, presence: true, length: { maximum: 50 }
  validates :body, length: { maximum: 100 }
  validates :pointer, presence: true
  validates :dashboard_id, presence: true

  attribute :pointer, :integer, default: 0

  def max_pointer
    items.size
  end

  def tick!(current = Time.current)
    return if current < timer.next_tick_at

    pointer_candidate = timer.tick!
    self.pointer = max_pointer <= pointer_candidate ? pointer_candidate - max_pointer : pointer_candidate

    save!
  end
end
