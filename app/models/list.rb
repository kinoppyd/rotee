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

  delegate :sunday?, :monday?, :tuesday?, :wednesday?, :thursday?, :friday?, :saturday?, :none?, :trigger_day, to: :timer

  alias sun sunday?
  alias mon monday?
  alias tue tuesday?
  alias wed wednesday?
  alias thu thursday?
  alias fri friday?
  alias sat saturday?

  def max_pointer
    items.size
  end

  def tick!(current = Time.current)
    return if timer.nil?
    return if current < timer.next_tick_at

    pointer_candidate = timer.tick!
    self.pointer = max_pointer <= pointer_candidate ? pointer_candidate - max_pointer : pointer_candidate

    save!
  end
end
