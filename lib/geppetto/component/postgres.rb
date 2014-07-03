module Geppetto
  module Component
    class Postgres < Base

      def process!
        if @builder.database_type == 'postgresql'
          %w{ manifests/install_postgresql.pp }.each do |file|
            @builder.add_named_template(file)
          end

          @builder.add_dependency('puppetlabs/postgresql')
        end
      end

    end
  end
end
