# Monkey-patching bootstrap-sass method for getting sprockets context
# bootstrap-sass is monkey-patching sass method, and seems to be doing it
# incorrectly in this version
#
# bootstrap-sass-3.1.1.1/lib/bootstrap-sass/sass_functions.rb
module Sass::Script::Functions

  def sprockets_context
    # Modern way to get context:
    if options.key?(:sprockets)
      options[:sprockets][:context]
      # Compatibility with sprockets pre 2.10.0:
    elsif (importer = options[:importer]) && importer.respond_to?(:context)
      importer.context
    elsif options.key?(:custom)
      # This is the monkey-patched condition that is added
      options[:custom][:sprockets_context]
    end
  end

end
