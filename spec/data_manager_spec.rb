require "rspec"
require_relative "../lib/brewfridge"

describe 'data file manager' do

  it 'should list available files' do
    dm = DataManager.new
    dm.list_files.length.should > 0
  end

  it 'should create google chart array' do
    dm = DataManager.new
    ca = dm.google_chart_array "20130520"
    ca.length.should > 0
  end
end