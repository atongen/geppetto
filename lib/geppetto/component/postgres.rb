module Geppetto
  module Component
    class Postgres < Base

      def process!
        if @builder.database_type == 'postgresql'
          %w{ manifests/install_postgresql.pp }.each do |file|
            @builder.add_named_template(file)
          end
        end
      end

    end
  end
end
