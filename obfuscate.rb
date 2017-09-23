#!/usr/bin/ruby
# Tool to run the obfuscator
$: << File.expand_path(File.dirname(__FILE__))
require 'obfuscator'

args = ARGV
obfuscator = Obfuscator.new
obfuscator.obfuscate_file(args)



