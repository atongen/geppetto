class Vagrant < Thor::Group
  include RubyVirt::Thor::Base

  group_tasks do

    def create_vagrantfile_file
      template('Vagrantfile.erb', 'Vagrantfile')
    end

    def create_readme_file
      template('README.md.erb', 'README.md')
    end

  end

end
