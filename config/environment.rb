ENV['RACK_ENV'] ||= 'development'

Bundler.require

require 'pathname'

GeppettoRoot = Pathname.new(File.expand_path('../..', __FILE__))

$:.unshift(GeppettoRoot.join('lib'))
require 'geppetto'
