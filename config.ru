require_relative "lib/brewfridge"
require_relative "web/web_scheduler"
if File.exist? 'snapshot.yaml'
  FileUtils.cp 'snapshot.yaml', 'snapshot.yaml.bak'
end
WebScheduler.run!(:env => :production, :port => 80)