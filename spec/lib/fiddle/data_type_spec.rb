require 'spec_helper'

describe Fiddle::DataType do

  subject do
    build("1")
  end

  def build(s)
    described_class.new(s)
  end

  def convert(s)
    build(s).convert
  end

  describe "registry" do
    subject { described_class.registry }
    it { should have(5).items }
    it { should be_a(Hash) }
    its(:keys) { should =~ ["date", "datetime", "integer", "numeric", "string"] }
  end

  describe "Abstract" do
    metadata[:example_group][:described_class] = described_class::Abstract

    it 'should have a code' do
      Fiddle::DataType::Numeric.code.should == "numeric"
    end

  end

  describe "String" do
    metadata[:example_group][:described_class] = described_class::String

    it 'should declare valid operations' do
      described_class.operations.should =~ ["eq", "not_eq", "in", "not_in"]
    end

    it 'should convert correctly' do
      convert("string").should == "string"
      convert(" ").should be_nil
    end

  end

  describe "Numeric" do
    metadata[:example_group][:described_class] = described_class::Numeric

    it 'should declare valid operations' do
      described_class.operations.should =~ ["eq", "not_eq", "in", "not_in", "gt", "lt", "gteq", "lteq", "between"]
    end

    it 'should convert correctly' do
      convert("4.35").should == 4.35
      convert("--").should be_nil
    end

  end

  describe "Integer" do
    metadata[:example_group][:described_class] = described_class::Integer

    it { should be_a(Fiddle::DataType::Numeric) }

    it 'should convert correctly' do
      convert("4.35").should == 4
      convert("--").should be_nil
    end

  end

  describe "Datetime" do
    metadata[:example_group][:described_class] = described_class::Datetime

    it 'should declare valid operations' do
      described_class.operations.should =~ ["gt", "lt", "gteq", "lteq", "between"]
    end

    it 'should convert correctly' do
      convert("2009-09-09 09:09:09").should == Time.utc(2009, 9, 9, 9, 9, 9)
      convert("--").should be_nil
      convert("-3630").should < 60.minutes.ago
      convert("-3630").should > 61.minutes.ago
    end

  end

  describe "Date" do
    metadata[:example_group][:described_class] = described_class::Date

    it 'should declare valid operations' do
      described_class.operations.should =~ ["eq", "not_eq", "gt", "lt", "gteq", "lteq", "between"]
    end

    it 'should convert correctly' do
      convert("2009-09-09 09:09:09").should == Date.civil(2009, 9, 9)
      convert("2009-09-09").should == Date.civil(2009, 9, 9)
      convert("--").should be_nil
      convert("-5").should == 5.days.ago.to_date
      convert("+2").should == 2.days.from_now.to_date
    end

  end

end
