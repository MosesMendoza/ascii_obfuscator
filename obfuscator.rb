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
  # @return [Array[Hash]] array of hashes containing {:char => char, :count => count of char}
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
        characters_with_count << { :char => previous_char, :count => previous_char_count }
        previous_char = char
        previous_char_count = 1
      end
      # Make sure we don't lose the last element
      if index == contents_list.length - 1
        characters_with_count << { :char => previous_char, :count => previous_char_count }
      end
    end
    characters_with_count
  end

  # Given a set of characters and the array of hashes generated by
  # get_character_metrics, generate a new form of metrics. We want the index of
  # the character in the array, and the count. We don't need the character
  # itself anymore with our set. This looks like:
  # [
  #   { :index => 0, :count => 2 }
  #   { :index => 1, :count => 4 }
  # ]
  # @param [Array] character_set an array of unique characters
  # @param [Array[Hash]] character_metrics an array of hashes generated by
  #   #get_character_metrics
  # @return [Array[Hash]] array of {:index => Integer, :count => Integer}
  #   elements
  def character_metrics_to_location_array(character_set, character_metrics)
    location_array = []
    character_metrics.each do |char_and_count|
      char = char_and_count[:char]
      count = char_and_count[:count]
      location_array << {:index => character_set.index(char), :count => count }
    end
    location_array  
  end

  # @param [Array[Hash]] location_array array of {:index => Integer, :count =>
  #   Integer} elements
  # @return [Array[Hash]] an array of the same hashes, with an additional key,
  #   value pair whose value is the set of solutions returned by
  #   generate_set_of_divmods
  def divmods_for_all_locations(location_array)
    results = []
    location_array.each do |location_and_count|
      solutions = generate_set_of_divmods(100, location_and_count)
      results << location_and_count.merge(:solutions => solutions)
    end
    results
  end

  # @param [Integer] max_divmod the ceiling divmod operand to search up to
  # @param [Hash] location_and_count {:index => Integer, :count => Integer}
  # @return [Array[Array]] Array of two element arrays representing all possible
  #   divmod operands between 1 and 100 that together result in this :index,
  #   :count result. For example, given {:index => 1, :count => 17}, return an
  #   array containing such elements as [54, 37]
  def generate_set_of_divmods(max_divmod, location_and_count)
    index = location_and_count[:index]
    count = location_and_count[:count]
    results = []
    (0..max_divmod).each do |operand_x|
      (1..max_divmod).each do |operand_y|
        if operand_x.divmod(operand_y) == [index, count]
          results << [operand_x, operand_y]
        end
      end
    end
    results
  end
end

