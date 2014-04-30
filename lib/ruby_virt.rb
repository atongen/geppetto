require 'active_support/core_ext/string'

module RubyVirt
  VERSION = '0.0.1'
end

require 'ruby_virt/helpers'
require 'ruby_virt/bootstrap_sass'
require 'ruby_virt/zipper'
require 'ruby_virt/builder'

require 'ruby_virt/thor/base'
require 'ruby_virt/thor/vagrant'
require 'ruby_virt/thor/docker'
