ENV['RACK_ENV'] ||= 'development'
Bundler.require

require 'pathname'
GeppettoRoot = Pathname.new(File.expand_path('../..', __FILE__))

require 'dotenv'
Dotenv.load(GeppettoRoot.join('.env'))

$:.unshift(GeppettoRoot.join('lib'))
require 'geppetto'
