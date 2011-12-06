require 'bundler/setup'
require 'rails/engine'
require "active_record/railtie"
require 'inherited_resources'

SEQUEL_NO_CORE_EXTENSIONS = true
require 'sequel/core'

module Fiddle
  PATTERN = "[a-z_]+"
  REGEXP  = /\A#{PATTERN}\z/

  class Engine < Rails::Engine
    isolate_namespace Fiddle
  end

  def self.references(string)
    return [] if string.blank?
    string.scan(/\W?(#{PATTERN})\W?\./).flatten.uniq
  end
end
