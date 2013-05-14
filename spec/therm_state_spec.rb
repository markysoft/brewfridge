require "rspec"
require_relative "../lib/brewfridge"

sensor_a = "a"
sensor_b = "b"
describe "Persistence of ThermState" do

  it "should persist itself to a yaml file" do
    state = ThermState.new(["one", "two"], 4)
    filename = "./state.yaml"
    state.save filename
    File.exist?(filename).should == true
  end

  it "should recover itself from a yaml file" do
    state = ThermState.new([sensor_a, sensor_b], 4)
    state.increment_index
    state.update_temp(sensor_a, 15)
    state.update_temp(sensor_b, 17)
    filename = "./state.yaml"
    state.save filename
    recovered_state = YAML.load(File.read(filename))
    recovered_state.current_temperature(sensor_a).should == 15
    recovered_state.current_temperature(sensor_b).should == 17
  end
end

describe "Recording temperature" do
  it "should record a fixed size list of readings" do
    #program double
    manager = double("manager")
    manager.stub(:read_temp).with(sensor_a).and_return(21,22,23,19)
    state = ThermState.new([sensor_a], 4)
    4.times { state.refresh_readings manager }
    state.temp_data[sensor_a].length.should == 4
    state.current_temperature(sensor_a).should == 19
  end

  it "should return current temperature for a sensor" do
    #program double
    manager = double("manager")
    manager.stub(:read_temp).with(sensor_a).and_return(12,13)
    manager.stub(:read_temp).with(sensor_b).and_return(22,23)
    state = ThermState.new([sensor_a, sensor_b], 4)
    2.times { state.refresh_readings manager }
    state.current_temperature(sensor_a).should == 13
    state.current_temperature(sensor_b).should == 23
  end

  it "should overwrite oldest reading when list size exceeded" do
    manager = double("manager")
    manager.stub(:read_temp).with(sensor_a).and_return(21,22,23,19)
    state = ThermState.new([sensor_a], 2)
    4.times { state.refresh_readings manager }
    state.temp_data[sensor_a].should == [23, 19]
  end

  it "should return summary of max, min and current sensor readings" do
    manager = double("manager")
    manager.stub(:read_temp).with(sensor_a).and_return(25,17,23,18,22,19)
    manager.stub(:read_temp).with(sensor_b).and_return(11,10,17,19,21,20)
    state = ThermState.new([sensor_a, sensor_b], 4)
    6.times { state.refresh_readings manager }
    summary = state.summary
    summary.length.should == 2
    summary[0].sensor.should == sensor_a
    summary[0].current.should == 19
    summary[0].min.should == 18
    summary[0].max.should == 23
    summary[1].sensor.should == sensor_b
    summary[1].current.should == 20
    summary[1].min.should == 17
    summary[1].max.should == 21
  end
end