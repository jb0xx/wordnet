def compare_files(canonical_file, student_file)
  while true
    canonical_line = canonical_file.gets
    while canonical_line && canonical_line !~ /\S/	# no non-whitespace char
      canonical_line = canonical_file.gets
    end

    student_line = student_file.gets
    while student_line && student_line !~ /\S/
      student_line = student_file.gets
    end

    return true if (canonical_line == nil) && (student_line == nil)

    if (canonical_line != nil) && (student_line == nil)
      puts "FAILED: expecting more output!\n"
      exit(1)
    end
  
    if (canonical_line == nil) && (student_line != nil)
      puts "FAILED: too much output!\n"
      exit(1)
    end
  
    canonical_line.strip! 	# remove leading/training whitespace
    student_line.strip! 	# remove leading/training whitespace

    cStr = canonical_line.split(" ").join(" ")  # normalize internal whitespace
    sStr = student_line.split(" ").join(" ")	# normalize internal whitespace

    return false if cStr != sStr
  end
end

def do_comparison(canonical_filename, student_filename)
  File.open(canonical_filename) do |canonical_file|
    File.open(student_filename) do |student_file|
      if !compare_files(canonical_file, student_file)
        return false
      end
    end
  end
  
  return true
end

def do_test(test_name, test_command)
  canonical_output = "outputs/" + test_name + ".out"
  student_output = "student_outputs/" + test_name + ".out"
  
  command_line = test_command + " > " + student_output + "  2>/dev/null "
  system(command_line)
  if $? != 0
    puts "FAILED: Ruby returned a non-zero value, there are Ruby syntax errors"
  end
  
  if do_comparison(canonical_output, student_output)
    puts "PASSED\n"
    exit(0)
  else
    puts "FAILED\n"
    exit(1)
  end
end

if ARGV.length != 2
  puts "Usage: test.rb <test_name> \"<test_command>\""
  exit(1)
end

test_name = ARGV[0]
test_command = ARGV[1]

do_test(test_name, test_command)
