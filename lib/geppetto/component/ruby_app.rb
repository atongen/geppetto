module Geppetto
  module Component
    class RubyApp < Base

      def process!
        if @builder.ruby_app
          %w{ puppet/shell/app_setup.sh }.each do |file|
            @builder.add_sym_template(file)
          end

          %w{ manifests/install_app.pp
              files/database.yml
              files/setup_native.sh }.each do |file|
            @builder.add_named_template(file)
          end
        end
      end

    end
  end
end
