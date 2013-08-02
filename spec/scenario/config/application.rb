require File.expand_path('../boot', __FILE__)
Bundler.require

require "active_record/railtie"
require "fiddle"

module Dummy
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.eager_load = false
  end
end