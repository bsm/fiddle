require 'spec_helper'

describe Fiddle::Lookup do
  fixtures :fiddle_lookups, :fiddle_cubes
  it { should be_a(::Fiddle::Base) }

  # ----> ASSOCIATIONS
  it { should belong_to(:cube) }

  # ----> VALIDATIONS
  it { should validate_presence_of(:name) }
  it { should ensure_length_of(:name).is_at_most(30) }
  it { should validate_uniqueness_of(:name).scoped_to(:cube_id) }
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
  [:cube_id].each do |attribute|
    it { should_not allow_mass_assignment_of(attribute) }
  end

end
