require_relative "lib/brewfridge"
require_relative "web/web_scheduler"
if File.exist? 'snapshot.yaml'
  FileUtils.cp 'snapshot.yaml', 'snapshot.yaml.bak'
end
WebScheduler.run!(:env => :production, :bind => '0.0.0.0',  :port => 80)