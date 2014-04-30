ENV['RACK_ENV'] ||= 'development'

Bundler.require

require 'pathname'

RubyVirtRoot = Pathname.new(File.expand_path('../..', __FILE__))

$:.unshift(RubyVirtRoot.join('lib'))
require 'ruby_virt'
