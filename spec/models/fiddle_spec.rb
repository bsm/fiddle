require 'spec_helper'

describe Fiddle do

  it 'should extract references' do
    Fiddle.references("SUM(table.column)").should == ['table']
    Fiddle.references('SUM("table"."column")').should == ['table']
    Fiddle.references('SUM(`table`.`column`)').should == ['table']
    Fiddle.references('SUM(table.a + table.b)').should == ['table']
    Fiddle.references('SUM("a"."x1") / SUM(b."x2") * SUM("c".x3)').should == ['a', 'b', 'c']
  end

end
