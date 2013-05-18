class FridgeStatus
  attr_accessor :time, :heating, :temperatures

  def initialize(time, heating, temperatures)
    @time = time
    @heating = heating
    @temperatures = temperatures
  end
end
