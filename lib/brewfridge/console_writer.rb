class ConsoleWriter
  def print_temps(readings)
    5.times { puts ("\n") }
    puts ("    NOW   MAX   MIN")
    puts ("--------------------")
    readings.each_with_index do |r, i|
      puts "t#{i+1}  #{sprintf("%04.1f",r.current)}  #{sprintf("%04.1f", r.max)}  #{sprintf("%04.1f", r.min)}"
    end
    4.times { puts ("\n") }
    puts Time.now.strftime("Updated at: %H:%M:%S")
  end
end