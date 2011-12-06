require 'spec_helper'

describe Fiddle::Measure do

  it { should be_a(::Fiddle::Projection) }
  its(:group_sql) { should be_nil }

end
