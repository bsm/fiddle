require 'spec_helper'

describe Fiddle::Universe do
  fixtures :fiddle_universes

  it { should have_many(:cubes).dependent(:destroy) }
  it { should have_many(:lookups).dependent(:destroy) }

  it { should validate_presence_of(:name) }
  it { should ensure_length_of(:name).is_at_most(40) }
  it { should validate_uniqueness_of(:name).case_insensitive }

  it { should validate_presence_of(:uri) }
  it { should ensure_length_of(:uri).is_at_most(255) }

  ["postgres://user:pass@localhost:5432/db_name?key=value", "sqlite::memory:"].each do |value|
    it { should validate_format_of(:uri).with(value) }
  end
  ["not-an-URI", "localhost"].each do |value|
    it { should_not validate_format_of(:uri).with(value) }
  end

  [:name, :uri].each do |attribute|
    it { should allow_mass_assignment_of(attribute) }
  end
  [:created_at].each do |attribute|
    it { should_not allow_mass_assignment_of(attribute) }
  end

  it 'should fail if URI is not connectable' do
    subject.uri = "postgres://user:pass@127.0.0.1:22/db_name?key=value"
    subject.should have(1).error_on(:uri)
    subject.errors[:uri].first.should include("cannot be connected")
  end

  it 'should fail adapter is unavailable' do
    subject.uri = "do:mysql://example.com/db_name"
    subject.should have(1).error_on(:uri)
    subject.errors[:uri].first.should include("cannot be connected. No such adapter")
  end

  it 'should connect to URI' do
    subject.uri = "sqlite::memory:"
    subject.should have(:no).errors_on(:uri)
  end

  it 'should have an adapter' do
    subject.adapter.should be_nil
    fiddle_universes(:sqlite).adapter.should == 'sqlite'
  end

  it 'should store connections' do
    fiddle_universes(:sqlite).conn.should be_a(Sequel::Database)
    described_class.stored_connections.keys.should == [951813764]
  end

  it 'should remove connections on save' do
    fiddle_universes(:sqlite).conn
    described_class.should have(1).stored_connections
    fiddle_universes(:sqlite).save!
    described_class.should have(:no).stored_connections
  end

  it 'should remove connections on destroy' do
    subject = create(:universe)
    subject.conn
    described_class.should have(1).stored_connections
    subject.destroy
    described_class.should have(:no).stored_connections
  end

end
