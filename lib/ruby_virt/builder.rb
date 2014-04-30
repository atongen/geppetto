require 'active_model'

module RubyVirt
  class Builder
    include ::ActiveModel::Validations

    attr_accessor :params

    validates :format,
      inclusion: %w{ vagrant docker }

    def initialize(params = {})
      @params = params
    end

    def zip_data
      script = thor_class.new(*[thor_args, thor_opts, thor_config])
      # Thor::Group#invoke_all returns array of return values
      # for each task executed
      zip_path = script.invoke_all.last
      begin
        zip_data = File.read(zip_path)
      ensure
        File.unlink(zip_path)
      end
      zip_data
    end

    def name
      @name ||= "#{Time.now.strftime('%Y%m%d%H%M%S')}-#{format}"
    end

    def format
      params[:format]
    end

    private

    def thor_class
      case format
      when 'vagrant'
        Vagrant
      when 'docker'
        Docker
      end
    end

    def thor_args
      [nil]
    end

    def thor_opts
      { auto: true }
    end

    def thor_config
      {}
    end
  end
end
