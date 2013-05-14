require_relative "lib/brewfridge"
puts "starting in 5 seconds..."
sleep 5
if File.exist? 'snapshot.yaml'
  FileUtils.cp 'snapshot.yaml', 'snapshot.yaml.bak'
end

fc = FridgeController.new()
fc.run