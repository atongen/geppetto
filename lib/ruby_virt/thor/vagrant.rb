class Vagrant < Thor::Group
  include RubyVirt::Thor::Base

  class_option :provider, type: :string, required: :true
  class_option :box_url, type: :string, required: true
  class_option :ami, type: :string, required: false

  group_tasks do

    def create_vagrantfile_file
      template('Vagrantfile.erb', 'Vagrantfile')
    end

    def create_readme_file
      template('README.md.erb', 'README.md')
    end

  end

end
