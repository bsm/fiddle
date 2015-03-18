require 'spec_helper'

describe Fiddle::Lookup do
  fixtures :fiddle_lookups, :fiddle_universes

  before do
    fiddle_universes(:sqlite).conn.create_table :dim_publishers do
      primary_key :id
      String :name
    end

    fiddle_universes(:sqlite).conn.create_table :dim_websites do
      primary_key :id
      String :name
      Integer :publisher_id
    end
  end

  after do
    fiddle_universes(:sqlite).conn.drop_table :dim_publishers
    fiddle_universes(:sqlite).conn.drop_table :dim_websites
  end

  it { should be_a(::Fiddle::Base) }

  # ----> ASSOCIATIONS
  it { should belong_to(:universe) }

  # ----> VALIDATIONS
  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_most(30) }
  it { should validate_uniqueness_of(:name).scoped_to(:universe_id) }
  ["example", "an_example", "_example"].each do |value|
    it { should allow_value(value).for(:name) }
  end
  ["An example", "1Up", "1up", "hi5"].each do |value|
    it { should_not allow_value(value).for(:name) }
  end

  it { should validate_presence_of(:clause) }
  it { should validate_length_of(:clause).is_at_most(2000) }

  it { should validate_presence_of(:label_clause) }
  it { should validate_length_of(:label_clause).is_at_most(255) }

  it { should validate_presence_of(:value_clause) }
  it { should validate_length_of(:value_clause).is_at_most(255) }

  it { should_not validate_presence_of(:parent_value_clause) }
  it { should validate_length_of(:parent_value_clause).is_at_most(255) }

  # ----> ATTRIBUTES

  if Fiddle.protected_attributes?
    [:name, :clause, :label_clause, :value_clause, :parent_value_clause].each do |attribute|
      it { should allow_mass_assignment_of(attribute) }
    end

    [:universe_id].each do |attribute|
      it { should_not allow_mass_assignment_of(attribute) }
    end
  end

  # ----> INSTANCE METHODS

  it 'should build select sql' do
    fiddle_lookups(:publishers).select_sql.should == "id AS value, name AS label"
    fiddle_lookups(:websites).select_sql.should == "id AS value, name AS label, publisher_id AS parent_value"
  end

  it 'should build from sql' do
    fiddle_lookups(:publishers).from_sql.should == "(SELECT * FROM dim_publishers WHERE id > 0) publishers"
  end

  it 'should build order sql' do
    fiddle_lookups(:publishers).order_sql.should == "label"
  end

  it 'should build a dataset' do
    fiddle_lookups(:publishers).dataset.should be_a(Sequel::Dataset)
    fiddle_lookups(:publishers).dataset.sql.should == %(SELECT id AS value, name AS label FROM (SELECT * FROM dim_publishers WHERE id > 0) publishers ORDER BY label)
    fiddle_lookups(:publishers).dataset.to_a.should == []
  end

end
