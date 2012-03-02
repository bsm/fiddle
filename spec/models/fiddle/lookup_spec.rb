require 'spec_helper'

describe Fiddle::Lookup do
  fixtures :fiddle_lookups, :fiddle_universes

  before do
    fiddle_universes(:sqlite).conn.create_table :dim_websites do
      primary_key :id
      String :name
    end
  end

  after do
    fiddle_universes(:sqlite).conn.drop_table :dim_websites
  end

  it { should be_a(::Fiddle::Base) }

  # ----> ASSOCIATIONS
  it { should belong_to(:universe) }

  # ----> VALIDATIONS
  it { should validate_presence_of(:name) }
  it { should ensure_length_of(:name).is_at_most(30) }
  it { should validate_uniqueness_of(:name).scoped_to(:universe_id) }
  ["example", "an_example", "_example"].each do |value|
    it { should validate_format_of(:name).with(value) }
  end
  ["An example", "1Up", "1up", "hi5"].each do |value|
    it { should_not validate_format_of(:name).with(value) }
  end

  it { should validate_presence_of(:clause) }
  it { should ensure_length_of(:clause).is_at_most(2000) }

  it { should validate_presence_of(:label_clause) }
  it { should ensure_length_of(:label_clause).is_at_most(255) }

  it { should validate_presence_of(:value_clause) }
  it { should ensure_length_of(:value_clause).is_at_most(255) }

  # ----> ATTRIBUTES
  [:name, :clause, :label_clause, :value_clause].each do |attribute|
    it { should allow_mass_assignment_of(attribute) }
  end
  [:universe_id].each do |attribute|
    it { should_not allow_mass_assignment_of(attribute) }
  end

  # ----> INSTANCE METHODS

  it 'should build select sql' do
    fiddle_lookups(:websites).select_sql.should == "id AS value, name AS label"
  end

  it 'should build from sql' do
    fiddle_lookups(:websites).from_sql.should == "(SELECT * FROM dim_websites WHERE id > 0) websites"
  end

  it 'should build order sql' do
    fiddle_lookups(:websites).order_sql.should == "label"
  end

  it 'should build a dataset (private method)' do
    dataset = fiddle_lookups(:websites).send :dataset
    dataset.should be_a(Sequel::Dataset)
    dataset.sql.should == %(SELECT id AS value, name AS label FROM (SELECT * FROM dim_websites WHERE id > 0) websites ORDER BY label)
    dataset.to_a.should == []
  end

end
