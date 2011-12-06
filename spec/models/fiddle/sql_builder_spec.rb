require 'spec_helper'

describe Fiddle::SQLBuilder do
  fixtures :fiddle_cubes, :fiddle_projections, :fiddle_relations, :fiddle_constraints, :fiddle_universes

  def build(opts = {})
    described_class.new fiddle_cubes(:stats), opts
  end

  # Full example
  subject do
    build \
      :measures   => fiddle_projections(:page_views),
      :dimensions => fiddle_projections(:website_id, :date),
      :operations => [fiddle_constraints(:website__eq).operation('my'), fiddle_constraints(:page_views__gt).operation(1000)],
      :orders     => [Fiddle::SortOrder.new(fiddle_projections(:page_views), "DESC")]
  end

  it "should have a cube" do
    subject.cube.should == fiddle_cubes(:stats)
  end

  it "should have a dataset" do
    subject.dataset.should be_a(Sequel::Dataset)

    opts = subject.dataset.opts
    opts.keys.should =~ [:select, :from, :join, :where, :group, :having, :order, :offset, :limit]
    opts[:select].should =~ ["stats.website_id AS website_id", "stats.date AS date", "SUM(stats.page_views) AS page_views"]
    opts[:from].should =~ ["stats"]
    opts[:join].should =~ [" LEFT OUTER JOIN dim_websites AS websites ON websites.id = stats.website_id"]
    opts[:group].should =~ ["stats.date", "stats.website_id"]
    opts[:order].should =~ ["page_views DESC"]
    opts[:limit].should == 100
    opts[:offset].should == 0
  end

  it "should construct SQL statements" do
    subject.to_s.should match(/SELECT .+ FROM .+ LEFT OUTER JOIN .+ WHERE .+ GROUP BY .+ HAVING .+ ORDER BY .+ LIMIT .+ OFFSET/)
  end

=begin
  it "should build select clauses" do
    subject.select_clauses.should =~ [
      "SUM(stats.page_views) / (SUM(stats.visits) * 1.0) AS ppv",
      "SUM(stats.page_views) AS page_views",
      "SUM(stats.visits) AS visits",
      "stats.website_id AS website_id",
      "websites.name AS website_name",
      "stats.date AS date"]
    page_views_by_site.select_clauses.should =~ ["websites.name AS website_name", "SUM(stats.page_views) AS page_views"]
    total_page_views.select_clauses.should =~ ["SUM(stats.page_views) AS page_views"]
  end

  it "should build group clauses" do
    subject.group_clauses.should =~ ["stats.website_id", "websites.name", "stats.date"]
    page_views_by_site.group_clauses.should =~ ["websites.name"]
    total_page_views.group_clauses.should == []
  end

  it "should build where clauses" do

  end

  it "should build full SQL statements" do
    subject.to_s.should match(/SELECT .+? FROM stats LEFT OUTER JOIN dim_websites .+? GROUP BY .+?/)
    total_page_views.to_s.should_not include("JOIN")
  end
=end
end
