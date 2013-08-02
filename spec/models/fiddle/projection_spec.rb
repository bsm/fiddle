require 'spec_helper'

describe Fiddle::Projection do
  fixtures :fiddle_projections, :fiddle_cubes

  it { should belong_to(:cube) }
  it { should have_many(:constraints).dependent(:destroy) }

  it { should validate_presence_of(:cube) }
  it { should validate_presence_of(:name) }
  it { should ensure_length_of(:description).is_at_most(80) }
  it { should ensure_length_of(:name).is_at_most(30) }
  it { should validate_uniqueness_of(:name).case_insensitive.scoped_to(:cube_id) }
  ["example", "an_example", "_example"].each do |value|
    it { should allow_value(value).for(:name) }
  end
  ["An example", "1Up", "1up", "hi5"].each do |value|
    it { should_not allow_value(value).for(:name) }
  end
  it { should validate_presence_of(:clause) }
  it { should ensure_length_of(:clause).is_at_most(255) }

  it { should validate_presence_of(:type_code) }
  ["string", "integer", "datetime"].each do |value|
    it { should allow_value(value).for(:type_code) }
  end
  ["bogus", "monkey"].each do |value|
    it { should_not allow_value(value).for(:type_code) }
  end

  if Fiddle.protected_attributes?
    [:name, :description, :clause, :sortable, :type_code].each do |attribute|
      it { should allow_mass_assignment_of(attribute) }
    end

    [:cube_id].each do |attribute|
      it { should_not allow_mass_assignment_of(attribute) }
    end
  end

  it 'should ensure referenced tables are defined' do
    subject = fiddle_cubes(:stats).measures.new :name => "clicks", :clause => "SUM(stats.clicks)"
    subject.should have(:no).errors_on(:clause)

    subject = fiddle_cubes(:stats).dimensions.new :name => "page", :clause => "pages.name"
    subject.should have(1).error_on(:clause)
    subject.errors[:clause].should == ["contains missing references: pages"]
  end

  it 'should have a data type' do
    fiddle_projections(:website_name).type_class.should == Fiddle::DataType::String
  end

  it 'should have references' do
    fiddle_projections(:website_name).references.should == ['websites']
  end

  it 'should build select SQL' do
    fiddle_projections(:page_views).select_sql.should == "SUM(stats.page_views) AS page_views"
    fiddle_projections(:website_name).select_sql.should == "websites.name AS website_name"
  end

  it 'should build group SQL' do
    fiddle_projections(:page_views).group_sql.should be_nil
    fiddle_projections(:website_name).group_sql.should == "websites.name"
  end

end
