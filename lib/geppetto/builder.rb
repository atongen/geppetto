require 'active_model'

module Geppetto
  class Builder
    include ::ActiveModel::Validations

    attr_accessor :params,
                  :zip_dir,
                  :zip_file

    PARAMS = %w{
      name
      ruby_type
      ruby_version
      database
    }

    validates :name,
      format: /\A\w+\Z/

    def initialize(params = {})
      @params = params
      @zip = Zipper.new
      @built = false
    end

    def build!
      do_build
    end

    def built?
      !!@built
    end

    def zip_data
      @zip.to_s if built?
    end

    PARAMS.each do |param|
      class_eval <<-EOF
        def #{param}
          params[:#{param}]
        end
      EOF
    end

    private

    def do_build
      return if built?
      @built = true

      # All symetric files
      %w{ Vagrantfile
          puppet/Puppetfile
          puppet/env.vagrant.dist
          puppet/manifests/default.pp
          puppet/shell/main.sh
          puppet/shell/app_setup.sh }.each do |file|
        add_sym_template(file)
      end

      # All named module files
      %w{ manifests/install_postgresql.pp
          manifests/init.pp
          manifests/install_ruby.pp
          manifests/install_nginx.pp
          manifests/install_app.pp
          manifests/packages.pp
          files/bashrc
          files/database.yml
          files/vimrc
          files/xvfb_wkhtmltopdf.sh
          files/setup_native.sh
          files/README.md
          files/chruby.sh }.each do |file|
        add_template("puppet/modules/name/#{file}", "puppet/modules/#{name}/#{file}")
      end

      # Special named files
      add_template("puppet/modules/name/files/name.conf", "puppet/modules/#{name}/#{name}.conf")

      # Directories
      %w{ puppet/run }.each do |dir|
        add_directory(dir)
      end
    end

    def template_path(template_name)
      GeppettoRoot.join("templates/#{template_name}.erb")
    end

    def add_template(template_name, destination_name)
      b = binding
      template = File.read(template_path(template_name))
      rendered = ERB.new(template).result(b)
      @zip.add_file(destination_name, rendered)
    end

    # Convenience method for adding a template with a symetric destination name
    def add_sym_template(template_name)
      add_template(template_name, template_name)
    end

    def add_directory(dir)
      @zip.add_directory(dir)
    end

  end
end
