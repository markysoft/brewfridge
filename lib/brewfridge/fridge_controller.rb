class FridgeController

  TOP_DIR = File.dirname(__FILE__) + '/../..'

  attr_accessor :settings, :state

  def initialize
    @settings = load_settings()
    heating = false
    @heat_controller = HeatController.new(@settings, heating)
    @sensor_manager = SensorManager.new()
    @state = ThermState.new(@settings.max_readings)
    @console_writer = ConsoleWriter.new
  end

  def load_settings
    YAML.load(File.read("#{TOP_DIR}/settings.yaml"))
  end

  def run
    begin
      manage_fridge()
    rescue => exception
      log_exception exception
      exit 0
    end
  end

  def manage_fridge
    while true
      refresh_state()
      sleep @settings.sleep_for
    end
  end

  def refresh_state
    if @sensor_manager.list_sensor_names.length == 0
      raise "No sensors connected!"
    end
    @state.refresh_fridge_status @sensor_manager
    fridge_temperature = @state.current_temperature(@settings.fridge_sensor)
    @state.heating = @heat_controller.update(fridge_temperature)

    @console_writer.print_temps @state.summary
    @state.save "snapshot.yaml"
  end

  def log_exception(exception)
    puts exception
    puts exception.backtrace
    open("#{TOP_DIR}/logs/error.log", 'a') { |f|
      f.puts exception
      f.puts exception.backtrace
    }
  end

end
