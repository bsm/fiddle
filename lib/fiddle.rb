require 'bundler/setup'
require 'rails/engine'
require "active_record/railtie"
require 'inherited_resources'

SEQUEL_NO_CORE_EXTENSIONS = true
require 'sequel/core'

module Fiddle
  PATTERN = "[a-z_]+"
  REGEXP  = /\A#{PATTERN}\z/

  mattr_accessor :max_connections
  @@max_connections = 4

  class Engine < Rails::Engine
    isolate_namespace Fiddle
  end

  def self.references(string)
    return [] if string.blank?
    string.scan(/\W?(#{PATTERN})\W?\./).flatten.uniq
  end

  def self.protected_attributes?
    ActiveRecord::VERSION::MAJOR < 4 || defined?(ProtectedAttributes)
  end

  def self.strong_parameters?
    ActiveRecord::VERSION::MAJOR > 3 || defined?(StrongParameters)
  end

  def self.configure(&block)
    tap(&block)
  end

end
