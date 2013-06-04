class DataManager

  DATA_DIR = File.dirname(__FILE__) + '/../../data/'

  def initialize (data_dir = DATA_DIR)
    @data_dir = data_dir
  end

  def load_fridge_statuses_from_file filename
    recovered_states = []
    File.open(filename, "r").each_line do |line|
      j = FridgeStatus.new
      j.from_json! line
      t = j.time
      recovered_states << j
    end
    recovered_states
  end

  def heating_csv filename
    results = []
    states = load_fridge_statuses_from_file @data_dir + filename
    results <<  "time,heating"

    last_heating = nil
    states.each do |state|
      state_time = Time.parse(state.time).strftime("%Y/%m/%d %H:%M:%S")
      if heater_switched(last_heating, state.heating)
        #ensures we get a vertical line in chart
        results << "#{state_time},#{last_heating ? 1 : 0}"
      end
      results << "#{state_time},#{state.heating ? 1 : 0}"
      last_heating = state.heating
    end

    results
  end

  def heater_switched(last_heating, current_heating)
    last_heating != nil && last_heating != current_heating
  end

  def temps_csv filename
    results = []
    states = load_fridge_statuses_from_file @data_dir + filename
    if states.length > 0
      results <<  write_header(states[0].temperatures.length)
    end

    states.each do |state|
      row = Time.parse(state.time).strftime("%Y/%m/%d %H:%M:%S")
      state.temperatures.each_value do |temp|
        row += ",#{temp}"
      end
      results << row
    end

    results
  end

  def write_header(sensors)
    header = 'time'
    (1..sensors).each do |index|
      header += ",t#{index}"
    end
    header
  end

  def list_files
    Dir.entries(@data_dir).select { |d| d.start_with?("20") }.sort
  end

end