class { "site::packages": require => Stage["main"] }
class { "site::postgresql": require => Class["site::packages"] }
class { "site::ruby": require => Class["site::postgres"] }
class { "site::app": require => Class["site::ruby"] }
class { "site::nginx": require => Class["site::app"] }

class site {
  Exec {
    path => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin']
  }

  group { 'puppet':
    ensure => present,
  }

  group { 'vagrant':
    ensure => present
  }

  user { 'vagrant':
    ensure => present,
    home => '/home/vagrant',
    gid => 'vagrant',
    shell => '/bin/bash',
    require => Group['vagrant']
  }

  file { '/home/vagrant':
    ensure => directory,
    owner => 'vagrant',
    group => 'vagrant',
    mode => 0750,
    require => User['vagrant']
  }

  group { 'geppetto':
    ensure => present
  }

  user { 'geppetto':
    ensure => present,
    home => '/home/geppetto',
    gid => 'geppetto',
    shell => '/bin/bash',
    require => Group['geppetto']
  }

  file { '/home/geppetto':
    ensure => directory,
    owner => 'geppetto',
    group => 'geppetto',
    mode => 0750,
    require => User['geppetto']
  }

  file { '/home/vagrant/bin':
    ensure => directory,
    require => File['/home/vagrant']
  }

  group { 'nerdery':
    ensure => present
  }

  user { 'nerdery':
    ensure => present,
    home => '/home/nerdery',
    gid => 'nerdery',
    shell => '/bin/bash',
    groups => ['sudo'],
    require => Group['nerdery']
  }

  file { '/home/nerdery':
    ensure => directory,
    owner => 'nerdery',
    group => 'nerdery',
    mode => 0750,
    require => User['nerdery']
  }

  exec { 'update-locale':
    command => 'update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8',
  }

  class { 'timezone':
    timezone => 'America/Chicago',
  }

  include packages
  include ruby
  include tmux
  include vim
  include app
}
