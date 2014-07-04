class site::packages {

  package { 'build-essential':
    ensure => present
  }

  package { 'ntp':
    ensure => present
  }

  

  
  package { 'nodejs':
    ensure => present
  }
  

  
  package { ['vim', 'vim-nox']:
    ensure => present
  }
  

  
  package { 'tmux':
    ensure => present
  }
  

  

  

  

}
