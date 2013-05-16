class FridgeController

  TOP_DIR = File.dirname(__FILE__) + '/../..'

  attr_accessor :settings, :state

  def initialize
    @settings = load_settings()
    @heat_controller = HeatController.new(@settings, false)
    @sensor_manager = SensorManager.new()
    @state = ThermState.new(@sensor_manager.list_sensor_names, @settings.max_readings)
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
    @state.refresh_readings @sensor_manager
    @heat_controller.update @state.current_temperature(@settings.fridge_sensor)
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
