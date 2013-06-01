require_relative "../lib/brewfridge"

require 'sass'
class SassHandler < Sinatra::Base
  set :views, File.dirname(__FILE__) + '/views/stylesheets'
  get '/sass/*.css' do
    filename = params[:splat].first
    scss filename.to_sym
  end
end

class WebScheduler < Sinatra::Base
  use SassHandler

  helpers do
    def snippet(template, options={}, locals={})
      erb template, options.merge(:layout => false), locals
    end
  end

  scheduler = Rufus::Scheduler.start_new
  FC = FridgeController.new()
  DM = DataManager.new()

  scheduler.every "#{FC.settings.sleep_for}s" do
    FC.refresh_state
  end

  get '/' do
    erb :index
  end

  get '/charts' do
    erb :charts, :locals => {:data_files => DM.list_files}
  end

  get '/charts/:name' do
    ca = DM.google_chart_array params[:name]
    erb :chart, :locals => {:date => params[:name], :data => ca}
  end
  get '/charts/csv/:name' do
    ca = DM.dygraphs_csv params[:name]
    ca.join("\n")
  end

  get '/manage' do
    erb :manage, :locals => {:sensors => FC.sensor_manager.list_sensor_names}
  end

  post '/update_settings' do
    FC.save_settings params[:settings]
    redirect "/"
  end

  get '/summary' do
    json = "{ "
    FC.state.summary.each do |state|
      json += state.to_json + ","
    end
    json.chomp(",") + " }"
  end

  run! if app_file == $0
  FC.refresh_state
end