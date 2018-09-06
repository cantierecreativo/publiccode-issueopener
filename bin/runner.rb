#!/usr/bin/env ruby
require "dotenv/load"

while true do
  puts "Running main script"
  begin
    system "pwd"
    load "./bin/main.rb"
  rescue StandardError => e
    puts "------------- Error running main script --------------"
    puts e.message
    puts e.backtrace.join("\n")
    puts "------------------------------------------------------"
  end
  puts "Sleeping #{ENV["EXEC_INTERVAL"]} seconds..."
  sleep ENV["EXEC_INTERVAL"].to_i
end
