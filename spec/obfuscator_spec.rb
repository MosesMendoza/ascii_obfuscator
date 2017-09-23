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
end
