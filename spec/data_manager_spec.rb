require "rspec"
require_relative "../lib/brewfridge"


describe 'data file manager' do

  data_dir = File.dirname(__FILE__) + '/fixtures/data/'
  dm = DataManager.new data_dir
  it 'should list available files' do
    dm.list_files.length.should > 0
  end

  it 'should create google chart array' do
    ca = dm.google_chart_array "20130520"
    ca.length.should eq 8
  end

  it 'should create dygraphs csv' do
    dy = dm.dygraphs_csv "20130520"
    dy.length.should eq 8
    dy[0].should eq 'time,t1,t2'
    dy[1].should eq "2013/05/20 16:57:22,20.312,19.625"
  end
end