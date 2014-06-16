require 'active_support/core_ext/string'

module Geppetto
  VERSION = '0.0.1'
end

require 'geppetto/helpers'
require 'geppetto/bootstrap_sass'
require 'geppetto/zipper'
require 'geppetto/builder'

require 'geppetto/thor/base'
require 'geppetto/thor/vagrant'
require 'geppetto/thor/docker'
