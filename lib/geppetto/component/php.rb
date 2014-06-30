module Geppetto
  module Component
    class Php < Base

      def process!
        if @builder.php
          @builder.add_dependency('example42/php', '0.0.1', git: 'banana', file: 'foobar')
        end
      end
    end
  end
end
