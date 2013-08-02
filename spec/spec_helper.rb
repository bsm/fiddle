ENV["RACK_ENV"] ||= 'test'

require 'rubygems'
require 'bundler/setup'
require 'fiddle'

require File.expand_path("../scenario/config/environment.rb", __FILE__)
require 'rspec/rails'
require 'shoulda/matchers'
require 'factory_girl'

Dir[Rails.root.join("../../spec/support/**/*.rb")].each {|f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.fixture_path = Fiddle::Engine.config.root.join('spec', 'fixtures')
  config.use_transactional_fixtures = true
  config.include FactoryGirl::Syntax::Methods
  config.render_views

  config.before :suite do
    load File.expand_path('../factories.rb', __FILE__)
    silence_stream(STDOUT) do
      ActiveRecord::Migrator.migrate Fiddle::Engine.config.root.join('db', 'migrate')
    end
  end

  config.before :all do
    self.class.set_fixture_class \
      fiddle_universes: Fiddle::Universe,
      fiddle_cubes: Fiddle::Cube,
      fiddle_projections: Fiddle::Projection,
      fiddle_relations: Fiddle::Relation,
      fiddle_constraints: Fiddle::Constraint,
      fiddle_lookups: Fiddle::Lookup
  end

end