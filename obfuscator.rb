#! /usr/bin/ruby

class Obfuscator
  # Simple entry point - just delegate to other functionality
  def obfuscate_file(args)
    contents = parse_args(args)
    character_set = get_character_set(contents)
    metrics = get_character_metrics(contents)
    puts character_set.join.dump
    puts metrics
  end
  # @param [Array] args the arguments to the script. must be one element,
  #   consisting of a string representing the path to a file on disk @return
  # @return [String] the contents of the given file path
  def parse_args(args)
    if args.size == 1 && file_contents = File.read(args[0])
      puts "parsing file #{args[0]}"
    else
      raise "could not read file at path #{args[0]}"
    end
    file_contents
  end

  # @param [String] file_contents the contents of the ascii art image to
  #   obfuscate
  # @return [Array] an Array containing a single instance of every character in
  #   order of appearance in file_contents. We use Array rather than Set because
  #   its more full-featured in ruby.
  def get_character_set(file_contents)
    file_contents.split('').uniq
  end

  # @param [String] file_contents the contents of the ascii art image to obfuscate
  # @return [Array[Hash]] array of hashes containing {char => count of char}
  def get_character_metrics(file_contents)
    # first, generate an array of hashes representing an ordered list of
    # characters with the associated number of consecutive times it appears in the
    # text, before another character appears
    characters_with_count = []
    # split the file_contents into an array of characters
    contents_list = file_contents.split('')
    previous_char = contents_list[0]
    previous_char_count = 0

    contents_list.each_with_index do |char, index|
      if char == previous_char
        previous_char_count += 1
      else
        characters_with_count << { previous_char => previous_char_count }
        previous_char = char
        previous_char_count = 1
      end
      # Make sure we don't lose the last element
      if index == contents_list.length - 1
        characters_with_count << { previous_char => previous_char_count }
      end
    end
    characters_with_count
  end
end