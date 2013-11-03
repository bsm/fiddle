require 'spec_helper'

describe Fiddle::ParamParser do
  fixtures :fiddle_cubes, :fiddle_projections, :fiddle_relations, :fiddle_constraints

  def build(*a)
    described_class.new fiddle_cubes(:stats), *a
  end

  def where(hash)
    build(where: hash).operations.map do |o|
      [o.constraint.param_key, o.class.code, *o.sql_args]
    end
  end

  subject do
    build
  end

  it "should have a parent" do
    subject.parent.should == fiddle_cubes(:stats)
  end

  it "should should parse measures" do
    subject.measures.map(&:id).should =~ fiddle_projections(:page_views, :visits, :ppv).map(&:id)
    build(select: "page_views").measures.should =~ [fiddle_projections(:page_views)]
    build(select: ["page_views", "ppv", "invalid"]).measures.should =~ fiddle_projections(:page_views, :ppv)
    build(select: "page_views|ppv|invalid").measures.should =~ fiddle_projections(:page_views, :ppv)
    build(select: ["page_views|ppv|invalid"]).measures.should =~ fiddle_projections(:page_views, :ppv)
    build(select: ["page_views|invalid", "ppv"]).measures.should =~ fiddle_projections(:page_views, :ppv)
    build(select: "page_views|page_views").measures.should =~ [fiddle_projections(:page_views)]
    build(select: "invalid_a|invalid_b").measures.map(&:id).should =~ subject.measures.map(&:id)
  end

  it "should NOT allow measures to be empty" do
    build(by: "website_id").measures.map(&:id).should =~ fiddle_projections(:page_views, :visits, :ppv).map(&:id)
  end

  it "should should parse dimensions" do
    subject.dimensions.should == []
    build(by: "website_id").dimensions.should =~ [fiddle_projections(:website_id)]
  end

  it "should allow dimensions to be empty" do
    build(select: "ppv").dimensions.should == []
  end

  it "should should parse sort orders" do
    subject.orders.should == []
    build(order: "website_id.desc|page_views").orders.should have(1).item

    orders = build(by: 'website_id', order: "website_id.desc|page_views").orders
    orders.should have(2).items
    orders.first.should be_a(Fiddle::SortOrder)
    orders.should == ["website_id DESC", "page_views ASC"]

    build(by: 'website_id', order: ["website_id.0", "page_views.1"]).orders.should == ["website_id ASC", "page_views DESC"]
    build(by: 'website_id', order: ["website_id.d"]).orders.should == ["website_id DESC"]
    build(by: 'website_id', order: ["website_id.x"]).orders.should == ["website_id ASC"]
    build(by: 'website_id', order: ["invalid.d"]).orders.should == []
  end

  it "should parse limits" do
    subject.limit.should == 100
    build(limit: "30").limit.should == 30
    build(per_page: "30").limit.should == 30
    build(limit: 20, per_page: "30").limit.should == 20
  end

  it "should parse offsets" do
    subject.offset.should == 0
    build(offset: "200").offset.should == 200
    build(page: "2", per_page: 30).offset.should == 30
    build(offset: "200", page: 3, per_page: "30").offset.should == 200
    build(page: "1").offset.should == 0
    build(page: "2").offset.should == 100
    build(page: "0").offset.should == 0
  end

  it 'should parse operations' do
    subject.operations.should == []
    where("WRONG").should == []
    where("page_views__in" => "1|2").should == []
    where("page_views__gt" => "1").should == [['page_views.gt', 'gt', 1]]
    where("page_views__gt" => "1").should == [['page_views.gt', 'gt', 1]]
    where("page_views__gt" => "A").should == []
    where("page_views__gt" => "1", "website__eq" => "my", "date__between" => "-30..-1").should =~ [
      ['page_views.gt', 'gt', 1],
      ['website.eq', 'eq', "my"],
      ['date.between', 'between', 30.days.ago.to_date, 1.day.ago.to_date]
    ]
  end

  it 'should convert to options hash' do
    subject.to_hash.keys.should =~ [:operations, :dimensions, :limit, :measures, :offset, :orders]
    subject.to_hash.values_at(:dimensions, :measures, :operations, :orders).map(&:size).should == [0, 3, 0, 0]
  end

end
