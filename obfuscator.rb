#! /usr/bin/ruby

class Obfuscator
  # @param [Array] args the arguments to the script. must be one element,
  #   consisting of a string representing the path to a file on disk @return
  # @return [String] the contents of the given file path
  def parse_args(args)
    if args.size == 1 && file_contents = File.read(args[0])
      puts "parsing file #{args[0]}"
    else
      raise "could not read file at path #{args[0]}"
    end
  end
  file_contents
end
