require 'active_model'

module RubyVirt
  class Builder
    include ::ActiveModel::Validations

    attr_accessor :params
    PARAM_KEYS = %w{
      name
      format
      provider
      box_url
    }

    validates :format,
      inclusion: %w{ vagrant docker }
    validates :name,
      format: /\A\w+\Z/

    # Vagrant validations
    validates :provider,
      inclusion: %w{ virtualbox aws },
      if: ->{ format == "vagrant" }

    # virutalbox validations
    validates :box_url,
      presence: true,
      if: -> { provider == "virtualbox" }

    # aws validations
    validates :ami,
      presence: true,
      if: -> { provider == "aws" }

    def initialize(params = {})
      @params = params
    end

    def zip_data
      script = thor_script
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

    # Instantiates the Thor::Group for these params
    def thor_script
      thor_class.new(*[thor_args, thor_opts, thor_config])
    end

    PARAM_KEYS.each do |key|
      class_eval <<-EOF
        def #{key}; params[:#{key}]; end
      EOF
    end

    private

    def thor_class
      case format
      when 'vagrant'
        ::Vagrant
      when 'docker'
        ::Docker
      end
    end

    def thor_args
      [nil]
    end

    def thor_opts
      PARAMS_KEYS.select { |k| k != "format" }.inject({}) do |mem,k|
         val = send(k)
         mem[k.to_sym] = val if val.present?
         mem
      end
    end

    def thor_config
      {}
    end
  end
end
