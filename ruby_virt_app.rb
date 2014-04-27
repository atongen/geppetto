Bundler.require

$:.unshift(File.expand_path('../lib', __FILE__))
require 'ruby_virt'

class RubyVirtApp < Sinatra::Application
  set :assets_precompile, %w{ application.css *.png *.jpg *.svg *.eot *.ttf *.woff }
  register Sinatra::AssetPipeline

  helpers do
    include Sinatra::Cookies
    include RubyVirt::Helpers
  end

  get '/' do
    erb :index
  end

  post '/' do
    vagrant = RubyVirt::Vagrant.new(params[:vagrant])
    vagrant.zip!
    send_file vagrant.path,
      type: 'application/octet-stream',
      disposition: 'attachment',
      filename: 'vagrant.zip'
  end
end
