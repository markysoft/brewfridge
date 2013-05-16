class ThermState
  attr_accessor :list_index, :temp_data, :looped, :heating

  DATA_PATH = "/home/pi/brew/rt/data"

  def initialize (sensors, max_readings)
    @looped = false
    @list_index = -1
    @temp_data = init_temp_data sensors
    @list_max = max_readings
  end

  def init_temp_data(sensors)
    temp_data = {}
    sensors.each {|name| temp_data[name] = []}
    temp_data
  end

  def increment_index
    @list_index += 1
    if @list_index >= @list_max
      @list_index = 0
      @looped = true
      save "#{DATA_PATH}/#{Time.now.to_f}.yaml"
      #puts "Has looped!"
    end
  end

  def refresh_readings manager
    increment_index
    @temp_data.each_key do |sensor|
      temp = manager.read_temp sensor
      update_temp(sensor, temp)
    end
  end

  def update_temp(name, temp)
    if @looped
      @temp_data[name][@list_index] = temp
    else
      @temp_data[name] << temp
    end
  end

  def current_temperature(sensor)
    @temp_data[sensor][@list_index]
  end

  def summary()
    readings = []
    @temp_data.each_key do |sensor|
      ts = TempSummary.new
      ts.sensor = sensor
      ts.current = current_temperature(sensor)
      ts.min, ts.max = @temp_data[sensor].minmax
      ts.mean = @temp_data[sensor].mean
      readings << ts
    end
    readings
  end

  def save(filename)
    File.open(filename, 'w') {|f| f.write(YAML.dump(self)) }
  end
end