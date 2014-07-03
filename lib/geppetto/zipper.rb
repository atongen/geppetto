require 'zip'

module Geppetto
  class Zipper

    def initialize
      @zip = ::Zip::OutputStream.new(::StringIO.new(''), true)
    end

    def to_s
      @zip.close_buffer.string
    end

    def add_file(path, content)
      @zip.put_next_entry(path)
      @zip.write(content)
    end

    def add_directory(path)
      p = path.dup
      p << '/' unless p[-1,1] == '/'
      @zip.put_next_entry(p)
    end

  end
end
