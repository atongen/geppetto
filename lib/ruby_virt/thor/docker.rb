class Docker < Thor::Group
  include RubyVirt::Thor::Base

  def create_readme_file
    template('README.md.erb', 'README.md')
  end

  def create_dockerfile_file
    template('Dockerfile.erb', 'Dockerfile')
  end

end
