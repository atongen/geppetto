require File.expand_path('../geppetto_app', __FILE__)

use Rack::Session::Cookie, key: 'geppetto.session',
  expire_after: 31536000, # one year
  secret: ENV['SESSION_SECRET']

apps = []

apps << GeppettoApp.new

apps << Opal::Server.new do |s|
  s.main = 'application'
  s.append_path 'opal'
  s.debug = ENV['DEBUG'] == 'true'
end

run Rack::Cascade.new(apps)
