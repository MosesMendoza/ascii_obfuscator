#!/usr/bin/ruby
require 'spec_helper'
require 'obfuscator'


describe Obfuscator do
  describe "#parse_args" do
    let(:obfuscator) { Obfuscator.new }

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
end
