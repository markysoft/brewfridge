class SensorManager

  DEVICE_FOLDER = "/sys/bus/w1/devices"

  def initialize(sensors_dir = DEVICE_FOLDER, max_loops = 100)
    @sensors_dir = sensors_dir
    @max_loops = max_loops
  end

  def read_temperatures
    temperatures = {}
    list_sensor_names.each do |sensor|
      temp = read_temp sensor
      temperatures[sensor] = temp
    end
    temperatures
  end

  def list_sensor_names
    Dir.entries(@sensors_dir).select { |d| d.start_with?("28") }
  end

  def read_temp(filename)
    lines = read_lines get_sensor_path(filename)
    loop_count = 1
    until lines[0].include?("YES") or loop_count == @max_loops
      sleep(0.5)
      lines = read_lines get_sensor_path(filename)
      loop_count += 1
    end
    if validate_lines(lines)
      raise "Invalid sensor reading: #{lines}"
    end
    parse_temp(lines)
  end

  def parse_temp(lines)
    splits = lines[1].split('t=')
    Float(splits[1])/1000
  end

  def validate_lines(lines)
    lines.length != 2 || lines[1].include?("t=") == false
  end

  def get_sensor_path(filename)
    "#{@sensors_dir}/#{filename}/w1_slave"
  end

  def read_lines(filename)
    if File.exist? filename
      file = File.open(filename, "r")
      lines = file.readlines
      file.close
    else
      lines = ["SENSOR UNAVAILABLE"]
    end
    lines
  end
end