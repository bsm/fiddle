require 'spec_helper'

describe Fiddle::Cube do
  fixtures :fiddle_cubes, :fiddle_relations, :fiddle_projections, :fiddle_universes

  it { should belong_to(:universe) }
  it { should have_many(:relations).dependent(:destroy) }
  it { should have_many(:projections).dependent(:destroy) }
  it { should have_many(:dimensions) }
  it { should have_many(:measures) }
  it { should have_many(:constraints) }

  it { should validate_presence_of(:universe) }
  it { should validate_presence_of(:name) }
  it { should ensure_length_of(:name).is_at_most(30) }
  it { should validate_uniqueness_of(:name).case_insensitive.scoped_to(:universe_id) }
  ["example", "an_example", "_example"].each do |value|
    it { should allow_value(value).for(:name) }
  end
  ["An example", "1Up", "1up", "hi5"].each do |value|
    it { should_not allow_value(value).for(:name) }
  end
  it { should validate_presence_of(:clause) }
  it { should ensure_length_of(:clause).is_at_most(2000) }

  it 'should retrieve table aliases' do
    fiddle_cubes(:stats).table_aliases.should == ['stats', 'websites']
  end

  it 'should build a dataset' do
    fiddle_cubes(:stats).dataset.should be_a(Sequel::Dataset)
    fiddle_cubes(:stats).dataset.sql.should == "SELECT *"
  end

  it 'should have a from SQL' do
    fiddle_cubes(:stats).from_sql.should == "stats"
    fiddle_cubes(:stats).clause = "db.stats"
    fiddle_cubes(:stats).from_sql.should == "db.stats AS stats"
  end

end
