#!/usr/bin/env ruby

filename = $0
test_name = File.basename(filename, ".*")

tStr = test_name.split("_")  # split on _

command = "ruby wordnet.rb inputs/synsets1.txt inputs/hypernyms1.txt nouns"

puts "Testing: #{command}"

command_line = "ruby test.rb " + test_name + " \"#{command}\""
system(command_line)
if $? != 0
  exit(1)
end

