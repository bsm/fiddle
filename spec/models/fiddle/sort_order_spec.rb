require 'spec_helper'

describe Fiddle::SortOrder do
  fixtures :fiddle_projections

  def build(dir = 0)
    described_class.new fiddle_projections(:website_name), dir
  end

  subject do
    build
  end

  its(:projection) { should == fiddle_projections(:website_name) }
  its(:direction)  { should == "ASC" }

  it 'should parse directions' do
    build("desc").direction.should == "DESC"
    build("0").direction.should == "ASC"
    build("1").direction.should == "DESC"
    build("d").direction.should == "DESC"
    build("D").direction.should == "DESC"
    build("DSC").direction.should == "DESC"
    build("x").direction.should == "ASC"
  end

  it 'should build order SQL clauses' do
    subject.order_sql.should == "website_name ASC"
  end

  it 'should be comparable' do
    [subject].should == ["website_name ASC"]
  end

end