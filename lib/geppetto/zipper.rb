require 'zip'
require 'tempfile'

module Geppetto
  module Zipper

    def self.zip_file(directory, path = nil)
      return false unless File.directory?(directory)

      directory = File.expand_path(directory)
      if path
        file = File.open(path, 'w')
      else
        file = Tempfile.new('geppetto_zip')
      end

      begin
        # http://thinkingeek.com/2013/11/15/create-temporary-zip-file-send-response-rails/
        Zip::OutputStream.open(file.path) { |zipfile| }

        Zip::File.open(file.path, Zip::File::CREATE) do |z|
          Dir[File.join(directory, '**', '**')].each do |f|
            z.add(f.sub(directory+'/', ''), f)
          end
        end
      ensure
        file.close
      end

      file
    end

  end
end
