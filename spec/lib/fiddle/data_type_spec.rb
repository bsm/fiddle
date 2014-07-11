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
    it { expect(subject.keys).to match_array(["date", "datetime", "integer", "numeric", "string"]) }
  end

  describe "Abstract" do
    metadata[:described_class] = described_class::Abstract

    it 'should have a code' do
      expect(Fiddle::DataType::Numeric.code).to eq("numeric")
    end

  end

  describe "String" do
    metadata[:described_class] = described_class::String

    it 'should declare valid operations' do
      expect(described_class.operations).to match_array(["eq", "not_eq", "in", "not_in"])
    end

    it 'should convert correctly' do
      expect(convert("string")).to eq("string")
      expect(convert(" ")).to be_nil
    end

  end

  describe "Numeric" do
    metadata[:described_class] = described_class::Numeric

    it 'should declare valid operations' do
      expect(described_class.operations).to match_array(["eq", "not_eq", "in", "not_in", "gt", "lt", "gteq", "lteq", "between"])
    end

    it 'should convert correctly' do
      expect(convert("4.35")).to eq(4.35)
      expect(convert("--")).to be_nil
    end

  end

  describe "Integer" do
    metadata[:described_class] = described_class::Integer

    it { should be_a(Fiddle::DataType::Numeric) }

    it 'should convert correctly' do
      expect(convert("4.35")).to eq(4)
      expect(convert("--")).to be_nil
    end

  end

  describe "Datetime" do
    metadata[:described_class] = described_class::Datetime

    it 'should declare valid operations' do
      expect(described_class.operations).to match_array(["gt", "lt", "gteq", "lteq", "between"])
    end

    it 'should convert correctly' do
      expect(convert("2009-09-09 09:09:09")).to eq(Time.utc(2009, 9, 9, 9, 9, 9))
      expect(convert("--")).to be_nil
      expect(convert("-3630")).to be < 60.minutes.ago
      expect(convert("-3630")).to be > 61.minutes.ago
    end

  end

  describe "Date" do
    metadata[:described_class] = described_class::Date

    it 'should declare valid operations' do
      expect(described_class.operations).to match_array(["eq", "not_eq", "gt", "lt", "gteq", "lteq", "between"])
    end

    it 'should convert correctly' do
      expect(convert("2009-09-09 09:09:09")).to eq(Date.civil(2009, 9, 9))
      expect(convert("2009-09-09")).to eq(Date.civil(2009, 9, 9))
      expect(convert("--")).to be_nil
      expect(convert("-5")).to eq(5.days.ago.to_date)
      expect(convert("+2")).to eq(2.days.from_now.to_date)
    end

  end

end
