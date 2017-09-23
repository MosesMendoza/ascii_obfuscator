#!/usr/bin/ruby
require 'spec_helper'
require 'obfuscator'


describe Obfuscator do
  let(:obfuscator) { Obfuscator.new }
  describe "#parse_args" do
    it "should fail if more than one argument is supplied" do
      expect { obfuscator.parse_args(["foo", "bar"]) }.to raise_error(RuntimeError)
    end
    
    it "should fail passed the path to a file it cannot read" do
      expect { obfuscator.parse_args(["/foo/bar/baz"]) }.to raise_error(SystemCallError)
    end

    it "should read in a file given the path to one" do
      expect(File).to receive(:read).with("/foo/bar/baz").and_return("a b c")
      obfuscator.parse_args(["/foo/bar/baz"])
    end
  end

  describe "#get_character_metrics" do
    it "should return an array of hashes containing characters and their counts in a given string" do
      expect(obfuscator.get_character_metrics("abaaacc")).to eq(
        [
          { :char => "a", :count => 1 },
          { :char => "b", :count => 1 },
          { :char => "a", :count => 3 },
          { :char => "c", :count => 2 }
        ]
      )
    end
  end

  describe "#get_character_set" do
    it "should return array of uniq characters in a string" do
      expect(obfuscator.get_character_set("abbccaaa")).to eq(["a", "b", "c"])
    end
  end

  describe "#character_metrics_to_location_array" do
    context "given an array of unique characters and a metrics set from #get_character_metrics" do
      it "should return an array of hashes containing the index and count of each character" do
        char_array = ["c", "a", "b"]
        metrics_set = [
          { :char => "a", :count => 1 },
          { :char => "b", :count => 1 },
          { :char => "a", :count => 3 },
          { :char => "c", :count => 2 }
        ]
        expect(obfuscator.character_metrics_to_location_array(char_array, metrics_set)).to eq(
          [
            { :index => 1, :count => 1 },
            { :index => 2, :count => 1 },
            { :index => 1, :count => 3 },
            { :index => 0, :count => 2 }
          ]
        )
      end
    end
  end

  describe "#divmods_for_all_locations" do
    context "given an array of {:index => Integer, :count => Integer} hashes" do
      it "calculates divmod solutions for all elements using #generate_set_of_divmods" do
        location_array = [{ :index => 1, :count => 1 }, { :index => 2, :count => 1}]
        results = obfuscator.divmods_for_all_locations(location_array)
        first_location_results = results.first[:solutions]
        second_location_results = results[1][:solutions]
        expect(results.length).to eq(2)
        expect(first_location_results.length).to eq(98)
        expect(first_location_results).to include([29, 28], [46, 45])
        expect(second_location_results.length).to eq(48)
        expect(second_location_results).to include([93, 46], [27, 13])
      end 
    end
  end
  describe "#generate_set_of_divmods" do
    context "given a hash containing {:index => Integer, :count => Integer}" do
      it "returns an array of arrays representing Integer.divmod(Integer) pairs with solution :index, :count" do
        results = obfuscator.generate_set_of_divmods({:index => 1, :count => 17})
        # random selection of results
        expect(results).to include([42, 25], [77, 60], [94, 77])
        expect(results.length).to eq(66)
      end

      context "with no solutions under 100" do
        it "will 10x the solution space" do
          # 32, 4 has no solutions under 100, have to go to 1000
          results = obfuscator.generate_set_of_divmods({:index => 32, :count => 4})
          # random selection of results
          expect(results).to include([740, 23], [932, 29], [996, 31])
        end
      end
    end
  end
end
