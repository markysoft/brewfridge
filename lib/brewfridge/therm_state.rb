class ThermState
  attr_accessor :list_index, :looped, :status_list

  DATA_PATH = "/home/pi/brew/rt/data"

  def heating
    @heating
  end

  def heating=(heating)
    @heating = heating
    if @list_index >= 0
      @status_list[@list_index].heating = @heating
    end
  end

  def initialize (max_readings, heating = false)
    @looped = false
    @list_index = -1
    @status_list = []
    @list_max = max_readings
    @heating = heating
  end

  def last_reading_time
    if @list_index >= 0
      return @status_list[@list_index].time.strftime("%H:%M:%S")
    end
    "NA"
  end

  def get_next_index
    next_index = @list_index + 1
    looped = @looped
    if next_index >= @list_max
      next_index = 0
      looped = true
    end
    [next_index, looped]
  end

  def refresh_fridge_status manager
    fridge_status = FridgeStatus.new(Time.now, @heating, manager.read_temperatures)
    safe_list_update fridge_status
  end

  def safe_list_update(fridge_status)
    #only update @next_index, @looped after the array is written to prevent
    #threading issues where @next_index is nil or old data
    next_index, looped = get_next_index
    if looped
      @status_list[next_index] = fridge_status
    else
      @status_list << fridge_status
    end

    @looped = looped
    @list_index = next_index
  end

  def heater_utilisation
    if (@status_list.length > 0)
      100 * @status_list.select { |value| value.heating }.length / @status_list.length
    else
      0
    end

  end

  def summary()
    readings = []
    temperatures = {}

    @status_list.each do |status|
      status.temperatures.each_key do |key|
        if temperatures[key] == nil
          temperatures[key] = []
        end
        temperatures[key] << status.temperatures[key]
      end
    end

    temperatures.each_key do |sensor|
      ts = TempSummary.new
      ts.sensor = sensor
      ts.current = current_temperature(sensor)
      ts.min, ts.max = temperatures[sensor].minmax
      ts.mean =temperatures[sensor].mean
      readings << ts
    end
    readings
  end

  def update_temp(name, temp)
    if @looped
      @temp_data[name][@list_index] = temp
    else
      @temp_data[name] << temp
    end
  end

  def current_temperature(sensor)
    @status_list[@list_index].temperatures[sensor]
  end

  def append_readings(json_file)
    if (@list_index >= 0)
      open(json_file, 'a') do |f|
        f.puts "#{@status_list[@list_index].to_json}\n"
      end
    end
  end

  def save(filename)
    File.open(filename, 'w') { |f| f.write(YAML.dump(self)) }
  end
end