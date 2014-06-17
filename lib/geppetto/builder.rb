require 'active_model'

module Geppetto
  class Builder
    include ::ActiveModel::Validations

    attr_accessor :params,
                  :zip_dir,
                  :zip_file

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
      if File.file?(zip_file)
        FileUtils.remove_entry_secure(zip_file)
      end
      if File.directory?(zip_dir)
        FileUtils.remove_entry_secure(zip_dir)
      end
      true
    end

    def built?
      !!@built
    end

    def name
      params[:name]
    end

    def zip_data
      if built?
        File.read(zip_file)
      end
    end

    private

    def do_build
      add_sym_template("README.md")
    end

    def template_path(template_name)
      GeppettoRoot.join("templates/#{template_name}.erb")
    end

    def destination_path(destination_name)
      File.join(zip_dir, destination_name)
    end

    def add_template(template_name, destination_name)
      b = binding
      template = File.read(template_path(template_name))
      rendered = ERB.new(template).result(b)
      File.open(destination_path(destination_name), 'w') { |f| f.puts rendered }
    end

    # Convenience method for adding a template with a symetric destination name
    def add_sym_template(template_name)
      add_template(template_name, template_name)
    end

  end
end
