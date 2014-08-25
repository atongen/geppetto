module Geppetto
  module Component
    class Mysql < Base

      def process!
        if @builder.database_type == 'mysql'
          @builder.add_dependency('puppetlabs-mysql')

          %w{ manifests/mysql.pp }.each do |file|
            @builder.add_named_template(file)
          end
        end
      end

    end
  end
end
