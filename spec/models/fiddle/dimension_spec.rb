require 'spec_helper'

describe Fiddle::Dimension do

  it { should be_a(::Fiddle::Projection) }

  if Fiddle.protected_attributes?
    [:visible].each do |attribute|
      it { should allow_mass_assignment_of(attribute) }
    end
  end
end
