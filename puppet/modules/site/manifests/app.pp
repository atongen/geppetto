class site::app {
  file { "create .env file":
    path => "/vagrant/.env",
    source => "/vagrant/env.dist",
    replace => false,
  }

  exec { "bundle install":
    command => "chruby-exec ruby-2.1.2 -- bundle install",
    cwd => "/vagrant",
    require => Exec["install_bundler"]
  }
}