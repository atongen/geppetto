require 'sinatra/cookies'
require 'sinatra/reloader'
require 'rack-flash'

class GeppettoApp < Sinatra::Application
  configure :development do
    register Sinatra::Reloader
  end
  set :assets_precompile, %w{ application.css *.png *.jpg *.svg *.eot *.ttf *.woff }
  set :views, File.expand_path("../views", __FILE__)
  register Sinatra::AssetPipeline

  set :sessions, key: 'geppetto.session',
    expire_after: 31536000, # one year
    secret: ENV['SESSION_SECRET']
  use Rack::Flash

  helpers do
    include Sinatra::Cookies
    include Geppetto::Helpers
  end

  get '/' do
    erb :index
  end

  post '/' do
    @builder = Geppetto::Builder.new(params[:virt])
    if @builder.valid?
      begin
        @builder.build!
        zip_data = @builder.zip_data
      rescue => e
        flash[:alert] = "There was an error: #{e}"
        erb :index
      else
        attachment(@builder.name + '.zip')
        content_type('application/octet-stream')
        zip_data
      ensure
        @builder.cleanup
      end
    else
      erb :index
    end
  end
end
