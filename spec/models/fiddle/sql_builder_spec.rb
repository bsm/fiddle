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

  let :total_page_views do
    build :measures => fiddle_projections(:page_views)
  end

  let :page_views_by_site do
    build :measures => fiddle_projections(:page_views), :dimensions => fiddle_projections(:website_id, :website_name)
  end


  let :total_page_views do
    build :measures => fiddle_projections(:page_views)
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
    opts[:where].should be_a(Sequel::SQL::PlaceholderLiteralString)
    opts[:where].to_s(subject.dataset).should == "websites.name = 'my'"
    opts[:having].should be_a(Sequel::SQL::PlaceholderLiteralString)
    opts[:having].to_s(subject.dataset).should == "SUM(stats.page_views) > 1000"
  end

  it "should construct SQL statements" do
    subject.to_s.should match(/SELECT .+ FROM .+ LEFT OUTER JOIN .+ WHERE .+ GROUP BY .+ HAVING .+ ORDER BY .+ LIMIT .+ OFFSET/)
    page_views_by_site.to_s.should == "SELECT stats.website_id AS website_id, websites.name AS website_name, SUM(stats.page_views) AS page_views FROM stats LEFT OUTER JOIN dim_websites AS websites ON websites.id = stats.website_id GROUP BY stats.website_id, websites.name LIMIT 100 OFFSET 0"
    total_page_views.to_s.should == "SELECT SUM(stats.page_views) AS page_views FROM stats LIMIT 100 OFFSET 0"
  end

end
