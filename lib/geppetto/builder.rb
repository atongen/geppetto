require 'active_model'
require 'thread'

module Geppetto
  class Builder
    include ::ActiveModel::Validations

    attr_accessor :params,
                  :zip

    PARAMS = %w{
      name
      ruby_type
      ruby_version
      jruby_version
      database_type
      database_version
      java_type
      java_version
      php
      aws
      ruby_app
      nginx
      wkhtmltopdf
      tmux
      vim
      redis
      memcached
      nodejs
    }

    validates :name,
      format: /\A\w+\Z/

    # Ruby
    validates :ruby_type,
      inclusion: %w{ ruby },
      allow_blank: true
    validates :ruby_version,
      inclusion: %w{ 2.1.2 1.9.3 1.8.7 },
      if: proc { |b| b.ruby_type == 'ruby' }
    validates :ruby_version,
      inclusion: %w{ 1.7.12 1.6.8 },
      if: proc { |b| b.ruby_type == 'jruby' }

    # Java
    validates :java_type,
      inclusion: %w{ oracle openjdk },
      allow_blank: true
    validates :java_version,
      inclusion: %w{ 6 7 8 },
      if: proc { |b| b.java_type.present? }

    # Database
    validates :database_type,
      inclusion: %w{ postgresql mysql },
      allow_blank: true

    def initialize(params = {})
      @params = params
      @zip = Zipper.new
      @built = false
      @dependencies = []
      @binding = binding
      @mutex = Mutex.new
    end

    def zip_data
      do_build
      @zip.to_s
    end

    PARAMS.each do |param|
      class_eval <<-EOF
        def #{param}
          params[:#{param}]
        end
      EOF
    end

    def template_path(template_name)
      GeppettoRoot.join("templates/#{template_name}.erb")
    end

    def add_template(template_name, destination_name)
      template = File.read(template_path(template_name))
      rendered = ERB.new(template).result(@binding)
      @zip.add_file(destination_name, rendered)
    end

    # Convenience method for adding a template with a symetric destination name
    def add_sym_template(template_name)
      add_template(template_name, template_name)
    end

    # Convenience method for adding a template to the "name" module
    def add_named_template(file)
      add_template("puppet/modules/name/#{file}", "puppet/modules/#{name}/#{file}")
    end

    def add_directory(dir)
      @zip.add_directory(dir)
    end

    def add_dependency(dependency, version=nil, options={})
      @dependencies << Geppetto::Dependency.new(dependency, version, options)
    end

    private

    def do_build
      @mutex.synchronize do
        if !@built
          @built = true

          Component::Ruby.new(self).process!
          Component::Java.new(self).process!
          Component::RubyApp.new(self).process!
          Component::Postgres.new(self).process!
          Component::Php.new(self).process!
          Component::Mysql.new(self).process!

          Component::Extras.new(self).process!
          Component::Main.new(self).process!
        end
      end
    end

  end
end
