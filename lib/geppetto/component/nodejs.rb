module Geppetto
  module Component
    class Nodejs < Base

      def process!
        return if @builder.nodejs.empty?

        @builder.add_dependency('willdurand-nodejs')

        %w{ manifests/nodejs.pp }.each do |file|
          @builder.add_named_template(file)
        end
      end
    end
  end
end
