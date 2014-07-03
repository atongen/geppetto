module Geppetto
  module Helpers

    def base_url
      @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    end

    def pluralize(count, singular, plural = nil)
      word = if (count == 1 || count =~ /^1(\.0+)?$/)
        singular
      else
        plural || singular.pluralize
      end

      "#{count || 0} #{word}"
    end

  end
end
