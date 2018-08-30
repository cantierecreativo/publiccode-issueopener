#!/usr/bin/env ruby
require "dotenv/load"

while true do
  puts "Running main script"
  system("ruby", "main.rb")
  puts "Sleeping #{ENV["EXEC_INTERVAL"]} seconds..."
  sleep ENV["EXEC_INTERVAL"].to_i
end
