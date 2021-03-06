require 'bundler/setup'
require 'rails/engine'
require 'active_record/railtie'
require 'inherited_resources'
require 'sequel/core'

module Fiddle
  PATTERN = "[a-z_]+"
  REGEXP  = /\A#{PATTERN}\z/

  mattr_accessor :max_connections
  @@max_connections = 4

  class Engine < Rails::Engine
    isolate_namespace ::Fiddle
  end

  class << self

    def references(string)
      return [] if string.blank?
      string.scan(/\W?(#{PATTERN})\W?\./).flatten.uniq
    end

    def protected_attributes?
      ActiveRecord::VERSION::MAJOR < 4 || defined?(ProtectedAttributes)
    end

    def strong_parameters?
      ActiveRecord::VERSION::MAJOR > 3 || defined?(StrongParameters)
    end

    def configure(&block)
      tap(&block)
    end

  end
end

%w|version utils operation data_type param_parser sort_order sql_builder|.each do |name|
  require "fiddle/#{name}"
end