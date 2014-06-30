module Geppetto
  module Component
    class Php < Base

      def process!
        return unless @builder.php_version

        @builder.add_dependency('example42/php')

        if @builder.php_composer
          @builder.add_dependency('tPl0ch/composer', '1.2.1')
        end

        %w{ manifests/install_php.pp }.each do |file|
          @builder.add_named_template(file)
        end
      end
    end
  end
end
