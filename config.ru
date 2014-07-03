require File.expand_path('../config/environment', __FILE__)
require GeppettoRoot.join('geppetto_app')

apps = []

apps << GeppettoApp.new

apps << Opal::Server.new do |s|
  s.main = 'application'
  s.append_path 'opal'
  s.debug = ENV['DEBUG'] == 'true'
end

run Rack::Cascade.new(apps)
