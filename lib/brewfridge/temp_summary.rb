class TempSummary
  include JSONable
  attr_accessor :sensor, :current, :min, :max, :mean
end