require 'zip'
require 'tempfile'

module RubyVirt
  class Vagrant

    def initialize(params = {})
      @params = params
      @file = Tempfile.new('ruby_virt_zip')
      @zipped = false
    end

    def path
      @file.path
    end

    def zipped?
      !!@zipped
    end

    def zip!
      return true if zipped?
      Zip::ZipOutputStream.open(@file.path) do |zipfile|
        # add vagrant files to zip archive here!
        zipfile.put_next_entry("test.txt")
        zipfile.print "some test content!"
      end
      @file.close
      @zipped = true
    end

  end
end
