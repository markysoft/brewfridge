require "rspec"
require_relative "../lib/brewfridge"
SENSOR_PATH = File.dirname(__FILE__) + '/fixtures'

describe "Sensor manager" do

  it "should read temperature from a sensor" do
    manager = SensorManager.new(SENSOR_PATH)
    temp = manager.read_temp("28-A")
    temp.should == 22.5
  end

  it "should gracefully handle a disconnected sensor" do
    manager = SensorManager.new(SENSOR_PATH,2)
    expect{manager.read_temp("28-B")}.to raise_error('Invalid sensor reading: ["SENSOR UNAVAILABLE"]')
  end

  it "should list sensor names" do
    manager = SensorManager.new(SENSOR_PATH)
    names = manager.list_sensor_names
    names.length.should == 1
  end

  it "should re-read sensor until available if sensor is busy" do
    manager = SensorManager.new("/fakedir")
    manager.stub(:read_lines).with('/fakedir/fakesensor/w1_slave').and_return(["NO"], ["YES", "t=21700"])
    temp = manager.read_temp("fakesensor")
    temp.should == 21.7
  end

end