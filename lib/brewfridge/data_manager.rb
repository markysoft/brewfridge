class DataManager

  DATA_DIR = File.dirname(__FILE__) + '/../../data/'

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

    states = load_fridge_statuses_from_file DATA_DIR + filename
    states.each do |state|
      row = []
      row << Time.parse(state.time).strftime("%H:%M:%S")
      state.temperatures.each_value do |temp|
        row << temp
        results << row
      end

    end
    results
  end

  def list_files
    Dir.entries(DATA_DIR).select { |d| d.start_with?("20") }
  end
end