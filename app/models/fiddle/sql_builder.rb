class Fiddle::SQLBuilder

  attr_reader :cube, :select, :group, :where, :having, :order, :join, :limit, :offset

  # Constructor
  # @param [Cube] cube
  #   The cube
  # @param [Hash] opts options
  # @option [Array] measures
  # @option [Array] dimensions
  # @option [Hash]  operations
  # @option [Array] orders
  # @option [Array] limit
  # @option [Array] offset
  def initialize(cube, opts = {})
    normalize_opts! opts
    @cube   = cube
    @where  = opts[:operations].select {|o| o.projection.is_a?(Fiddle::Dimension) }
    @having = opts[:operations].select {|o| o.projection.is_a?(Fiddle::Measure) }
    @select = (opts[:dimensions] + opts[:measures] + @having.map(&:projection)).uniq
    @group  = opts[:dimensions]
    @join   = select_relations(opts)
    @order  = opts[:orders]
    @limit  = opts[:limit] || 100
    @offset = opts[:offset] || 0
  end

  def dataset
    @dataset ||= construct_scope
  end

  def to_s
    dataset.sql
  end

  protected

    def build(*args)
      @dataset = dataset.send(*args)
    end

    def construct_scope
      result = cube.dataset.
        select(*literalize(select.map(&:select_sql))).
        from(lit(cube.from_sql)).
        group(*literalize(group.map(&:group_sql))).
        order(*literalize(order.map(&:to_s))).
        clone :join => literalize(join.map(&:join_sql), " ")

      where.each do |op|
        result = result.where(op.where_sql)
      end

      having.each do |op|
        result = result.having(op.where_sql)
      end

      result.limit(limit, offset)
    end

    def normalize_opts!(opts)
      opts[:dimensions]  = Array.wrap(opts[:dimensions])
      opts[:measures]    = Array.wrap(opts[:measures])
      opts[:operations]  = Array.wrap(opts[:operations])
      opts[:orders]      = Array.wrap(opts[:orders])
    end

    def select_relations(opts)
      projections = opts[:dimensions] + opts[:measures] + opts[:operations].map(&:projection)
      references  = projections.map(&:references).flatten.uniq
      cube.relations.select {|r| references.include?(r.name) }
    end

    def literalize(items, prepend = nil)
      items.map {|i| lit("#{prepend}#{i}") }
    end

    def lit(string)
      Sequel::LiteralString.new(string)
    end

end
