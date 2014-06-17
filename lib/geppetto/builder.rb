require 'active_model'
require 'fileutils'

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
      @built = false
    end

    def build!
      @zip_dir = Dir.mktmpdir("geppettoo_dir")
      do_build
      @zip_file = Zipper.zip_file(@zip_dir).path
      @built = true
    end

    def cleanup
      if zip_file && File.file?(zip_file)
        FileUtils.remove_entry_secure(zip_file)
      end
      if zip_dir && File.directory?(zip_dir)
        FileUtils.remove_entry_secure(zip_dir)
      end
      true
    end

    def built?
      !!@built
    end

    def zip_data
      if built?
        File.read(zip_file)
      end
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

      mkdestination_dir('puppet/run')
    end

    def template_path(template_name)
      GeppettoRoot.join("templates/#{template_name}.erb")
    end

    def destination_path(destination_name)
      File.join(zip_dir, destination_name)
    end

    def mkdestination_dir(destination_dir)
      FileUtils.mkdir(File.join(zip_dir, destination_dir))
    end

    def add_template(template_name, destination_name)
      b = binding
      template = File.read(template_path(template_name))
      rendered = ERB.new(template).result(b)
      dir = File.dirname(File.join(zip_dir, destination_name))
      FileUtils.mkdir_p(dir) unless File.directory?(dir)
      File.open(destination_path(destination_name), 'w') { |f| f.puts rendered }
    end

    # Convenience method for adding a template with a symetric destination name
    def add_sym_template(template_name)
      add_template(template_name, template_name)
    end

  end
end
