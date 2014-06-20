module Geppetto
  module Component
    class Ruby < Base

      def process!
        if @builder.ruby_type
          %w{ manifests/install_ruby.pp
              files/chruby.sh }.each do |file|
            @builder.add_named_template(file)
          end
        end
      end

    end
  end
end
