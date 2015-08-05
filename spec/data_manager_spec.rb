require "rspec"
require_relative "../lib/brewfridge"


describe 'data file manager' do

  data_dir = File.dirname(__FILE__) + '/fixtures/data/'
  dm = DataManager.new data_dir
  it 'should list available files' do
    dm.list_files.length.should > 0
  end

  it 'should create json text' do
    dy = dm.chart_json "20130520"
    dy.length.should > 0
  end

  it 'should create dygraphs temps csv' do
    dy = dm.temps_csv "20130520"
    dy.length.should eq 8
    dy[0].should eq 'time,t1,t2'
    dy[1].should eq "2013/05/20 16:57:22,20.312,19.625"
  end

  it 'should create dygraphs heating csv' do
    dy = dm.heating_csv "20130520"
    dy.length.should eq 12
    dy[0].should eq 'time,heating'
    dy[1].should eq "2013/05/20 16:57:22,0"
    dy[2].should eq "2013/05/20 16:57:52,0"
    dy[3].should eq "2013/05/20 16:57:52,1"
  end
end