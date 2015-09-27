class ConsoleWriter
  def print_temps(state)
    5.times { puts ("\n") }
    puts ("    NOW   MAX   MIN")
    puts ("--------------------")
    state.summary.each_with_index do |r, i|
      puts "t#{i+1}  #{sprintf("%04.1f",r.current)}  #{sprintf("%04.1f", r.max)}  #{sprintf("%04.1f", r.min)}"
    end
    if (state.heating)
      puts ("\nHeater on")
    elsif
    puts ("\nHeater off")
    end
    2.times { puts ("\n") }
    puts Time.now.strftime("Updated at: %H:%M:%S")
  end
end