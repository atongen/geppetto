module RubyVirt
  module Thor
    module Base

      def self.included(base)
        raise("#{base} must extend Thor::Group") unless base < ::Thor::Group
        base.send :include, ::Thor::Actions

        # Set task arguments
        base.send :argument, :zip_path, optional: true
        base.send :argument, :auto, optional: true

        base.send :extend, ClassMethods
      end

      module ClassMethods
        def source_root
          RubyVirtRoot.join("templates/#{self.name.underscore}")
        end

        # We need to inject a first (init) and last (zip) task into
        # the Thor::Group task list
        #
        # Pass a block to this class method in the implementing class
        # to define the tasks, and the first and last tasks will
        # be added automatically.
        def group_tasks
          self.class_eval do
            def init
              self.destination_root = Dir.mktmpdir("ruby_virt_dir")
            end

            yield

            def zip
              begin
                file = RubyVirt::Zipper.zip_file(self.destination_root, zip_path)
              ensure
                FileUtils.remove_entry_secure(self.destination_root)
              end
              puts file.path unless auto
              file.path
            end
          end
        end
      end

    end
  end
end
