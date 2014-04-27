Bundler.require

$:.unshift(File.expand_path('../lib', __FILE__))
require 'ruby_virt'

class RubyVirtApp < Sinatra::Application
  set :assets_precompile, %w{ application.css *.png *.jpg *.svg *.eot *.ttf *.woff }
  register Sinatra::AssetPipeline

  helpers do
    include Sinatra::Cookies
    include Sprockets::Helpers
    include RubyVirt::Helpers
  end

  get '/' do
    erb :index
  end
end
