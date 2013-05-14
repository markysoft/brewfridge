class Settings
  attr_accessor  :sleep_for, :target_temp, :tolerance, :max_readings, :fridge_sensor, :toggle_command

  def save(filename)
    File.open(filename, 'w') {|f| f.write(YAML.dump(self)) }
  end

  def self.save_default_settings
    settings = create_default_settings()
    settings.save "settings.yaml"
  end

  def self.create_default_settings
    settings = Settings.new
    settings.sleep_for = 30
    settings.fridge_sensor = "28-000004955c1e"
    settings.max_readings = (24 * 60 * 60) / settings.sleep_for
    settings.target_temp = 20
    settings.tolerance= 0.1
  end
end