class HeatController

  TOP_DIR = File.dirname(__FILE__) + '/../..'

  def initialize(settings, heating)
    @target_temp = settings.target_temp
    @tolerance = settings.tolerance
    @toggle_exe = "#{TOP_DIR}/#{settings.toggle_command}"
    @heating = heating
  end

  def update(current_temperature)
    if not @heating and current_temperature < min_threshold
      puts "heat on"
      toggle_heater()
    elsif @heating and current_temperature >= @target_temp
      puts "heat off"
      toggle_heater()
    end
  end

  def toggle_heater
    success = system(@toggle_exe)
    if success
      @heating = !@heating
    end
    open("#{TOP_DIR}/logs/heater.log", 'a') { |f|
      f.puts "Toggled to: #{@heating} at #{Time.now} success: #{success}"
    }
  end

  def max_threshold
    (@target_temp + @tolerance)
  end

  def min_threshold
    @target_temp - @tolerance
  end
end