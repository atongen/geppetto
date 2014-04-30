require File.expand_path('../config/environment', __FILE__)

require 'sinatra/cookies'
require 'sinatra/reloader'

class RubyVirtApp < Sinatra::Application
  configure :development do
    register Sinatra::Reloader
  end
  set :assets_precompile, %w{ application.css *.png *.jpg *.svg *.eot *.ttf *.woff }
  set :views, File.expand_path("../views", __FILE__)
  register Sinatra::AssetPipeline

  helpers do
    include Sinatra::Cookies
    include RubyVirt::Helpers
  end

  get '/' do
    erb :index
  end

  post '/' do
    @builder = RubyVirt::Builder.new(params[:virt])
    if @builder.valid?
      attachment(@builder.name + '.zip')
      content_type('application/octet-stream')
      @builder.zip_data
    else
      erb :index
    end
  end
end
