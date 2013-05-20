class FridgeStatus
  include JSONable
  attr_accessor :time, :heating, :temperatures

  def initialize(time=nil, heating=false, temperatures={})
    @time = time
    @heating = heating
    @temperatures = temperatures
  end
end
