class site::ruby {

  # site::nginx depends on this ruby/version combination
  $ruby_type = "ruby"
  $ruby_version = "2.1.2"

  file { '/home/vagrant/src':
    ensure => 'directory'
  }

  exec { 'install_ruby_install':
    command => "wget -O ruby-install-0.4.3.tar.gz https://github.com/postmodern/ruby-install/archive/v0.4.3.tar.gz && \
                tar -xzvf ruby-install-0.4.3.tar.gz && \
                cd ruby-install-0.4.3/ && \
                make install",
    cwd     => "/home/vagrant/src",
    creates => "/usr/local/bin/ruby-install",
    require => File['/home/vagrant/src']
  }

  file { '/opt/rubies':
    ensure => 'directory',
    require => Exec['install_ruby_install']
  }

  exec { 'install_ruby_interpreter':
    command => "ruby-install ${ruby_type} ${ruby_version}",
    unless => "ls -1 /opt/rubies/${ruby_type}-${ruby_version}* > /dev/null 2>&1",
    require => File['/opt/rubies'],
    timeout => 0
  }

  exec { 'install_chruby':
    command => "wget -O chruby-0.3.8.tar.gz https://github.com/postmodern/chruby/archive/v0.3.8.tar.gz && \
                tar -xzvf chruby-0.3.8.tar.gz && \
                cd chruby-0.3.8/ && \
                make install",
    cwd     => "/home/vagrant/src",
    creates => "/usr/local/share/chruby/chruby.sh",
    require => Exec['install_ruby_interpreter']
  }

  file { '/etc/profile.d/chruby.sh':
    ensure => present,
    source => '/vagrant/puppet/modules/site/files/chruby.sh',
    require => Exec['install_chruby']
  }

  # without this we have an issue with ZenTest
  # https://github.com/seattlerb/zentest/issues/29
  exec { 'update_rubygems':
    command => "chruby-exec ${ruby_type}-${ruby_version} -- gem update --system",
    cwd =>  "/home/vagrant",
    require => File['/etc/profile.d/chruby.sh']
  }

  exec { 'install_bundler':
    command => "chruby-exec ${ruby_type}-${ruby_version} -- gem install bundler --no-rdoc --no-ri",
    cwd =>  "/home/vagrant",
    require => Exec['update_rubygems']
  }

}
