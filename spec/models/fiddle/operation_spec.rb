require 'spec_helper'

describe Fiddle::Operation do
  fixtures :fiddle_constraints, :fiddle_cubes, :fiddle_universes

  def build(code, *args)
    described_class.new constraint(code), *args
  end

  def constraint(code)
    c = Fiddle::Constraint.new
    c.projection = Fiddle::Projection.new :type_code => code, :clause => "table.field"
    c
  end

  subject do
    build "integer", "1"
  end

  describe "registry" do
    subject { described_class.registry }
    it { should have(9).items }
    it { should be_a(Hash) }
  end

  describe "Abstract" do
    metadata[:example_group][:described_class] = described_class::Abstract

    def build(code, *args)
      Fiddle::Operation::Eq.new constraint(code), *args
    end

    it 'should have a code' do
      described_class.code.should == "abstract"
      Fiddle::Operation::NotEq.code.should == "not_eq"
    end

    it 'should have a label' do
      described_class.label.should == "abstract"
      Fiddle::Operation::NotEq.label.should == "not equal"
      Fiddle::Operation::Gteq.label.should == "greater than or equal"
    end

    it 'should have an SQL clause' do
      subject.sql_clause.should == "= ?"
    end

    it 'should build SQL args' do
      build("string", "123").sql_args.should == ["123"]
      build("integer", "123").sql_args.should == [123]
      build("date", "2009-09-09").sql_args.should == [Date.civil(2009, 9, 9)]
    end

    it 'should be valid if SQL args can be built' do
      build("string", "123").should be_valid
      build("integer", "123").should be_valid
      build("date", "2009-09-09").should be_valid

      build("string", nil).should_not be_valid
      build("integer", "ABC").should_not be_valid
      build("date", "waffle").should_not be_valid
    end

    it 'should build SQL placeholder strings' do
      build("string", "123").where_sql.should be_a(Sequel::SQL::PlaceholderLiteralString)
      sql = ""
      build("string", "123").where_sql.to_s_append(fiddle_cubes(:stats).dataset, sql)
      sql.should == "table.field = '123'"
    end

    it 'should prevent invalid operation-type combinations' do
      Fiddle::Operation::Between.new(constraint("string"), "ABC").should_not be_valid
      Fiddle::Operation::Gteq.new(constraint("string"), "123").should_not be_valid

      Fiddle::Operation::Eq.new(constraint("string"), "ABC").should be_valid
      Fiddle::Operation::Gteq.new(constraint("integer"), "123").should be_valid
    end

    it 'can enforce valid operations' do
      Fiddle::Operation::Gteq.force_valid(constraint("string"), "123").should be_nil
      Fiddle::Operation::Eq.force_valid(constraint("string"), nil).should be_nil
      Fiddle::Operation::Eq.force_valid(constraint("string"), "ABC").should be_a(Fiddle::Operation::Eq)
    end

  end

  describe "Eq" do
    metadata[:example_group][:described_class] = described_class::Eq

    it 'should have an SQL clause' do
      subject.sql_clause.should == "= ?"
    end
  end

  describe "NotEq" do
    metadata[:example_group][:described_class] = described_class::NotEq

    it 'should have an SQL clause' do
      subject.sql_clause.should == "!= ?"
    end
  end

  describe "Between" do
    metadata[:example_group][:described_class] = described_class::Between

    it 'should build SQL args' do
      build("integer", "123..456").sql_args.should == [123, 456]
      build("integer", "-5..-1").sql_args.should == [-5, -1]
      build("date", "2011-11-11..2011-11-12").sql_args.should == [Date.civil(2011, 11, 11), Date.civil(2011, 11, 12)]

      build("integer", ['123', 456]).sql_args.should == [123, 456]
      build("integer", (123..456)).sql_args.should == [123, 456]

      build("integer", "WRONG").sql_args.should be_nil
      build("integer", "A..B").sql_args.should == [nil, nil]
      build("integer", "1..B").sql_args.should == [1, nil]
    end

    it 'should be valid if SQL args can be built' do
      build("integer", "123..456").should be_valid
      build("integer", "WRONG").should_not be_valid
      build("integer", "A..B").should_not be_valid
      build("integer", "1..B").should_not be_valid
    end

    it 'should have an SQL clause' do
      subject.sql_clause.should == "BETWEEN ? AND ?"
    end

    it 'should build SQL placeholder strings' do
      sql = ""
      build("integer", "123..456").where_sql.to_s_append(fiddle_cubes(:stats).dataset, sql)
      sql.should == "table.field BETWEEN 123 AND 456"
    end

  end

  describe "Gt" do
    metadata[:example_group][:described_class] = described_class::Gt

    it 'should have an SQL clause' do
      subject.sql_clause.should == "> ?"
    end
  end

  describe "Gte" do
    metadata[:example_group][:described_class] = described_class::Gteq

    it 'should have an SQL clause' do
      subject.sql_clause.should == ">= ?"
    end
  end

  describe "Lt" do
    metadata[:example_group][:described_class] = described_class::Lt

    it 'should have an SQL clause' do
      subject.sql_clause.should == "< ?"
    end
  end

  describe "Lte" do
    metadata[:example_group][:described_class] = described_class::Lteq

    it 'should have an SQL clause' do
      subject.sql_clause.should == "<= ?"
    end
  end

  describe "In" do
    metadata[:example_group][:described_class] = described_class::In

    it { should be_a(Fiddle::Operation::Collective) }

    it 'should have an SQL clause' do
      subject.sql_clause.should == "IN ?"
    end
  end

  describe "NotIn" do
    metadata[:example_group][:described_class] = described_class::NotIn

    it { should be_a(Fiddle::Operation::Collective) }

    it 'should have an SQL clause' do
      subject.sql_clause.should == "NOT IN ?"
    end
  end

  describe "Collective" do
    metadata[:example_group][:described_class] = described_class::In

    it { should be_a(Fiddle::Operation::Collective) }

    it 'should check validity' do
      build("integer", []).should_not be_valid
      build("integer", nil).should_not be_valid
      build("integer", "").should_not be_valid
      build("integer", {}).should_not be_valid
      build("string", "A").should be_valid
    end

    it 'should build SQL args' do
      build("integer", []).sql_args.should == []
      build("integer", nil).sql_args.should == []
      build("integer", "").sql_args.should == []
      build("integer", {}).sql_args.should == []
      build("string", "A").sql_args.should == [["A"]]
      build("string", :A).sql_args.should == [["A"]]
      build("string", [1,2,3]).sql_args.should == [["1", "2", "3"]]
      build("integer", [1,"2|3|4|5|6|  ||",3,4,5]).sql_args.should == [(1..6).to_a]
      build("integer", { 1 => 2 }).sql_args.should == [[1]]
    end

    it 'should build SQL placeholder strings' do
      sql = ""
      build("string", "A|B").where_sql.to_s_append(fiddle_cubes(:stats).dataset, sql)
      sql.should == "table.field IN ('A', 'B')"
    end

  end

end
