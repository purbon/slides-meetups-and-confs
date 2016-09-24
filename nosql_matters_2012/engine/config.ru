SINATRA_ROOT = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(SINATRA_ROOT, 'lib')
Dir.glob('lib/**').each{ |d| $LOAD_PATH.unshift(File.join(SINATRA_ROOT, d)) }

require 'rubygems'
require 'bundler'

Bundler.require

require 'app'
run App
