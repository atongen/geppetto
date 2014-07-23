module Geppetto
  module Component
    class Java < Base

      def process!
        if @builder.java_version
          %w{ manifests/java.pp
              files/java.preseed }.each do |file|
            @builder.add_named_template(file)
          end
        end
      end

    end
  end
end
