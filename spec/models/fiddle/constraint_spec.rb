require 'spec_helper'

describe Fiddle::Constraint do
  fixtures :fiddle_projections, :fiddle_constraints, :fiddle_cubes

  it { should belong_to(:cube) }
  it { should belong_to(:projection) }

  it { should validate_presence_of(:cube) }
  it { should validate_presence_of(:projection) }
  it { should validate_presence_of(:projection_id) }
  it { should validate_presence_of(:name) }
  it { should ensure_length_of(:name).is_at_most(30) }
  it { should validate_uniqueness_of(:name).case_insensitive.scoped_to([:cube_id, :operation_code]) }
  ["example", "an_example", "_example"].each do |value|
    it { should validate_format_of(:name).with(value) }
  end
  ["An example", "1Up", "1up", "hi5"].each do |value|
    it { should_not validate_format_of(:name).with(value) }
  end

  it { should validate_presence_of(:operation_code) }
  ["eq", "gteq", "between"].each do |value|
    it { should allow_value(value).for(:operation_code) }
  end
  ["bogus", "monkey"].each do |value|
    it { should_not allow_value(value).for(:operation_code) }
  end

  [:name, :projection_id, :operation_code].each do |attribute|
    it { should allow_mass_assignment_of(attribute) }
  end
  [:cube_id].each do |attribute|
    it { should_not allow_mass_assignment_of(attribute) }
  end

  it 'should ensure operation code matches the projection data type' do
    fiddle_constraints(:website__eq).operation_code = "gt"
    fiddle_constraints(:website__eq).should have(1).error_on(:operation_code)
    fiddle_constraints(:website__eq).errors[:operation_code].should == ["is not all applicable for this data type"]
  end

  it 'should ensure projection matches the cube' do
    fiddle_constraints(:website__eq).cube = fiddle_cubes(:meta_stats)
    fiddle_constraints(:website__eq).should have(1).error_on(:projection_id)
  end

  it 'should have an operation class' do
    subject.operation_class.should be_nil
    fiddle_constraints(:website__eq).operation_class.should == Fiddle::Operation::Eq
  end

  it 'should construct operations' do
    subject.operation("1").should be_nil
    fiddle_constraints(:website__eq).operation("my").should be_a(Fiddle::Operation::Eq)
  end

  it 'should have a parameter key' do
    fiddle_constraints(:website__eq).param_key.should == "website.eq"
  end

  it 'should have a description key' do
    fiddle_constraints(:website__eq).description.should == "Website Name"
  end

end
