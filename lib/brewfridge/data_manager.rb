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

  def google_chart_array filename
    results = []
    results << ['time', 't1', 't2']

    states = load_fridge_statuses_from_file @data_dir + filename
    states.each do |state|
      row = []
      row << Time.parse(state.time).strftime("%H:%M:%S")
      state.temperatures.each_value do |temp|
        row << temp
      end
      results << row

    end
    results
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