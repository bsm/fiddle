require 'spec_helper'

describe Fiddle::Dimension do

  it { should be_a(::Fiddle::Projection) }

  [:visible].each do |attribute|
    it { should allow_mass_assignment_of(attribute) }
  end

end
