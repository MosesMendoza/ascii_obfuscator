#! /usr/bin/ruby
# Augment load path to local directory
$: << File.expand_path(File.join('..'), File.dirname(__FILE__))
require 'rspec'
