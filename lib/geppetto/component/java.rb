module Geppetto
  module Component
    class Java < Base

      def process!
        if @builder.java_version
          %w{ manifests/install_java.pp }.each do |file|
            @builder.add_named_template(file)
          end
        end
      end

    end
  end
end
