module Geppetto
  class Dependency
    attr_reader :dependency, :version, :options

    def initialize(dependency, version=nil, options={})
      @dependency = dependency
      @version = version
      @options = options
    end

    def options_string
      self.options.map do |k, v|
        %Q[:#{k} => "#{v}"]
      end.join(', ')
    end

    def to_s
      components = []
      components << %Q("#{self.dependency}")
      components << %Q("#{self.version}") unless self.version.nil?
      components << self.options_string unless self.options.empty?

      "mod #{components.join(', ')}"
    end
  end
end