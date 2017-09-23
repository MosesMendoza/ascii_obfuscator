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
          { "a" => 1 },
          { "b" => 1 },
          { "a" => 3 },
          { "c" => 2 }
        ]
      )
    end
  end

  describe "get_character_set" do
    it "should return array of uniq characters in a string" do
      expect(obfuscator.get_character_set("abbccaaa")).to eq(["a", "b", "c"])
    end
  end
end
