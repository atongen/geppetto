module Geppetto
  module Component
    class Main < Base

      def process!
        %w{ Vagrantfile
            hiera.yaml
            puppet/Puppetfile
            puppet/manifests/default.pp
            puppet/shell/main.sh }.each do |file|
          @builder.add_sym_template(file)
        end

        # Named module files
        %w{ manifests/init.pp
            manifests/packages.pp
            files/bashrc
            files/vimrc
            files/README.md }.each do |file|
          @builder.add_named_template(file)
        end


        # Directories
        %w{ puppet/run }.each do |dir|
          @builder.add_directory(dir)
        end

        if @builder.aws
          @builder.add_sym_template('puppet/env.vagrant.dist')
        end

      end

    end
  end
end
