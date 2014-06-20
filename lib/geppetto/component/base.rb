module Geppetto
  module Component
    class Base

      attr_reader :buidler

      def initialize(builder)
        @builder = builder
      end

      def process!
        raise "Must override process! in #{self.class.name}"
      end

    end
  end
end
