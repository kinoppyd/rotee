class Timer
  # Utility for manage to day of week by binary
  class DayOfWeekInteger
    SUN = 0b0000001
    MON = 0b0000010
    TUE = 0b0000100
    WED = 0b0001000
    THU = 0b0010000
    FRI = 0b0100000
    SAT = 0b1000000

    ALL_DAYS = MON | TUE | WED | THU | FRI | SUN | SAT

    class InvalidStateError < StandardError; end

    class << self
      def from_symbols(*syms)
        stat = syms.inject(0) do |acc, sym|
          case sym
          when :sun
            acc | SUN
          when :mon
            acc | MON
          when :tue
            acc | TUE
          when :wed
            acc | WED
          when :thu
            acc | THU
          when :fri
            acc | FRI
          when :sat
            acc | SAT
          else
            acc
          end
        end

        new(stat)
      end
    end

    def initialize(stat)
      raise InvalidStateError unless stat.kind_of?(Integer)

      @stat = stat
      raise InvalidStateError unless sanity?
    end

    def to_i
      raise InvalidStateError unless sanity?

      @stat
    end

    def sunday? = available?(SUN)
    def monday? = available?(MON)
    def tuesday? = available?(TUE)
    def wednesday? = available?(WED)
    def thursday? = available?(THU)
    def friday? = available?(FRI)
    def saturday? = available?(SAT)
    def none? = @stat == NONE

    private

    def available?(int)
      raise InvalidStateError unless sanity?

      (@stat & int).positive?
    end

    def sanity?
      0 <= @stat && @stat <= ALL_DAYS
    end
  end
end