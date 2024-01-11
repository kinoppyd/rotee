class Timer < ApplicationRecord
  include UuidPrimaryKey

  belongs_to :list

  validates :trigger_day, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: DayOfWeekInteger::NONE,
    less_than_or_equal_to: DayOfWeekInteger::ALL_DAYS
  }

  delegate :sunday?, :monday?, :tuesday?, :wednesday?, :thursday?, :friday?, :saturday?, :none?, to: :trigger_day

  def trigger_day
    DayOfWeekInteger.new(read_attribute(:trigger_day))
  end

  def trigger_day=(value)
    v = if value.kind_of?(Array)
          DayOfWeekInteger.from_symbols(*value).to_i
        else
          value.respond_to?(:to_i) ? value.to_i : errors.add(:trigger_day, 'should respond_to "to_i" or Array object')
        end

    # use tap to return "write_attribute" value
    write_attribute(:trigger_day, v).tap do
      self.next_tick_at = calc_next_tick
    end
  end

  def tick!(now = Time.current)
    return 0 if now < next_tick_at

    tick_count = (((last_ticked_at || created_at).tomorrow.to_date)..(now.to_date)).filter { |d| trigger?(d) }.count
    self.last_ticked_at = now if tick_count.positive?
    self.next_tick_at = calc_next_tick

    tick_count
  end

  private

  WDAY_METHOD_MAP = {
    0 => :sunday?,
    1 => :monday?,
    2 => :tuesday?,
    3 => :wednesday?,
    4 => :thursday?,
    5 => :friday?,
    6 => :saturday?,
  }.freeze

  def calc_next_tick(today = Time.zone.today)
    return last_ticked_at if trigger_day.none?

    tomorrow = today.tomorrow
    trigger_day.public_send(WDAY_METHOD_MAP[tomorrow.wday]) ? tomorrow : calc_next_tick(tomorrow)
  end

  def trigger?(date)
    trigger_day.public_send(WDAY_METHOD_MAP[date.wday])
  end
end
