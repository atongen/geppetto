require File.expand_path('../ruby_virt_app', __FILE__)
require 'sinatra/asset_pipeline/task'

Sinatra::AssetPipeline::Task.define! RubyVirtApp

namespace :assets do
  desc 'compile opal'
  task :precompile_opal do
    app = Opal::Server.new do |s|
      s.main = 'application'
      s.append_path 'opal'
      s.debug = false
    end
    sprockets = app.sprockets
    sprockets.js_compressor = Uglifier.new(mangle: true)
    asset     = sprockets['application.js']
    outfile   = 'public/assets/application.js'
    asset.write_to(outfile)
    asset.write_to("#{outfile}.gz")
  end

  task :precompile => :precompile_opal
end
