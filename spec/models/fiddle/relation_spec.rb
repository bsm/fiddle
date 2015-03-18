require 'spec_helper'

describe Fiddle::Relation do
  fixtures :fiddle_relations, :fiddle_cubes

  it { should belong_to(:cube) }
  it { should validate_presence_of(:cube) }

  it { should validate_presence_of(:name) }
  it { should validate_length_of(:name).is_at_most(30) }
  it { should validate_uniqueness_of(:name).case_insensitive.scoped_to(:cube_id) }
  ["example", "an_example", "_example"].each do |value|
    it { should allow_value(value).for(:name) }
  end
  ["An example", "1Up", "1up", "hi5"].each do |value|
    it { should_not allow_value(value).for(:name) }
  end
  it { should validate_presence_of(:operator) }
  described_class::OPERATORS.each do |value|
    it { should allow_value(value).for(:operator) }
  end
  ['CROSS JOIN', 'JUST wrong'].each do |value|
    it { should_not allow_value(value).for(:operator) }
  end
  it { should validate_presence_of(:predicate) }
  it { should validate_length_of(:predicate).is_at_most(2000) }
  it { should validate_presence_of(:target) }
  it { should validate_length_of(:target).is_at_most(2000) }

  it 'should ensure name is not clashing with cube name' do
    subject = fiddle_cubes(:stats).relations.new(:name => 'stats')
    subject.should have(1).error_on(:name)
  end

  if Fiddle.protected_attributes?
    [:name, :operator, :target, :predicate].each do |attribute|
      it { should allow_mass_assignment_of(attribute) }
    end

    [:cube_id].each do |attribute|
      it { should_not allow_mass_assignment_of(attribute) }
    end
  end

  it 'should build SQL' do
    subject.join_sql.should == ""
    fiddle_relations(:websites).join_sql.should == "LEFT OUTER JOIN dim_websites AS websites ON websites.id = stats.website_id"
  end

end
