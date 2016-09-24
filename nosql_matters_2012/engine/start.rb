#!/usr/bin/env ruby


dir = File.expand_path(File.dirname(__FILE__))
env = ARGV[0] || 'development'
jruby_opts = "-J-Xmx5G --1.9"

cmd = "cd #{dir} && export JRUBY_OPTS='#{jruby_opts}' && bundle exec rackup"

puts "Starting environment #{env} in #{dir}"
puts "Running #{cmd}"
result = %x[#{cmd}]
puts result
