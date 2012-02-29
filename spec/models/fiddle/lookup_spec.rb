require 'spec_helper'

describe Fiddle::Lookup do
  fixtures :fiddle_lookups, :fiddle_universes

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
    fiddle_lookups(:publishers).select_sql.should == "publishers.id AS id, publishers.name AS name"
  end

  it 'should build from sql' do
    fiddle_lookups(:publishers).from_sql.should == "( dim_publishers ) AS publishers"
  end

  it 'should build from sql' do
    fiddle_lookups(:publishers).order_sql.should == "name DESC"
  end

  it 'should build a dataset' do
    fiddle_lookups(:publishers).dataset.should be_a(Sequel::Dataset)
    opts = fiddle_lookups(:publishers).dataset.opts
    opts[:select].should  =~ ["publishers.id AS id, publishers.name AS name"]
    opts[:from].should    =~ ["( dim_publishers ) AS publishers"]
    opts[:order].should   =~ ["name DESC"]
  end

end
