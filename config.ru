require File.expand_path('../ruby_virt_app', __FILE__)

use Rack::Session::Cookie, key: 'ruby_virt.session',
  expire_after: 31536000, # one year
  secret: ENV['SESSION_SECRET']

apps = []

apps << RubyVirtApp.new

apps << Opal::Server.new do |s|
  s.main = 'application'
  s.append_path 'opal'
  s.debug = ENV['DEBUG'] == 'true'
end

run Rack::Cascade.new(apps)
