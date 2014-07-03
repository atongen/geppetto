require 'active_support/core_ext/string'

module Geppetto
  VERSION = '0.0.1'
end

require 'geppetto/helpers'
require 'geppetto/bootstrap_sass'
require 'geppetto/zipper'
require 'geppetto/dependency'
require 'geppetto/builder'

require 'geppetto/component/base'
require 'geppetto/component/extras'
require 'geppetto/component/java'
require 'geppetto/component/main'
require 'geppetto/component/mysql'
require 'geppetto/component/php'
require 'geppetto/component/postgres'
require 'geppetto/component/ruby'
require 'geppetto/component/ruby_app'
