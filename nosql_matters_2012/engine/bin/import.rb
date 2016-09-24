#!/usr/bin/env ruby

SINATRA_ROOT = File.expand_path(File.dirname('.'))
$LOAD_PATH.unshift File.join(SINATRA_ROOT, 'lib')
Dir.glob('lib/**').each{ |d| $LOAD_PATH.unshift(File.join(SINATRA_ROOT, d)) }

require 'rubygems'
require 'bundler'

Bundler.require

require 'silvia/silvia'
require 'bin/lib/movies'
require 'bin/lib/ratings'
require 'bin/lib/tags'

Silvia::Database.shutdown

inserter = Neo4j::Batch::Inserter.new

puts "Importing Movies"
movies_importer = Import::Movie.new(inserter)
movies_importer.perform('data/movies.dat')

puts "Ratings"
rating_importer = Import::Rating.new(inserter)
rating_importer.perform('data/ratings.dat')

puts "Tags"
tags_importer   = Import::Tag.new(inserter)
tags_importer.perform('data/tags.dat')

inserter.shutdown

raise Exception
