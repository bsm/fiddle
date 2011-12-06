FactoryGirl.define do

  sequence :name_alias do |n|
    base = "name"
    n.times { base = base.next }
    base
  end

  factory :universe, :class => "Fiddle::Universe" do
    name { FactoryGirl.generate(:name_alias) }
    uri  "sqlite::memory:"
  end

  factory :cube, :class => "Fiddle::Cube" do
    name   { FactoryGirl.generate(:name_alias) }
    clause "page_stats"
    universe
  end

  factory :dimension, :class => "Fiddle::Dimension", :aliases => [:projection] do
    type_code "string"
    cube
    name      { FactoryGirl.generate(:name_alias) }
    clause    { "#{cube.name}.column_name" }
  end

  factory :measure, :class => "Fiddle::Measure" do
    type_code "string"
    cube
    name      { FactoryGirl.generate(:name_alias) }
    clause    { "SUM(#{cube.name}.numeric_col)" }
  end

  factory :constraint, :class => "Fiddle::Constraint" do
    operation_code "eq"
    projection
    cube  { projection.cube }
    name  { FactoryGirl.generate(:name_alias) }
  end

end
