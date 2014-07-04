class site::tmux {

  file { '/home/vagrant/.tmux.conf':
    ensure => present,
    source => '/vagrant/puppet/modules/site/files/tmux.conf',
    replace => true,
    require => File['/home/vagrant/bin']
  }

}
