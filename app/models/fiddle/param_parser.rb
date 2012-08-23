class Fiddle::ParamParser
  include Fiddle::Utils

  attr_reader :parent, :measures, :dimensions, :operations, :orders, :offset, :limit

  # Constructor
  # @param [Cube|Object] parent
  # @param [Hash] options
  # @option [Array] select
  #   Names of the measures to select
  # @option [Array] by
  #   Names of the dimensions to group by
  # @option [Hash] where
  #   Key-value pairs containing where filters
  # @option [String] order
  #   Order string
  # @option [Integer] limit, defaults to 100
  #   Limit the number of records
  # @option [Integer] per_page
  #   Alias for limit
  # @option [Integer] offset
  #   Offset for selection
  # @option [Integer] page
  #   Page for selection, ignored if offset given
  def initialize(parent, options = nil)
    options     = {} unless options.is_a?(Hash)
    @parent     = parent

    @measures   = parse_collection parent.measures, options[:select]
    @measures   = parent.measures if @measures.empty?
    @dimensions = parse_collection parent.dimensions, options[:by]

    @orders     = parse_orders(options[:order])
    @limit      = parse_integer(options[:limit], options[:per_page], :default => 100)
    @offset     = parse_integer(options[:offset], page_offset(options[:page]))
    @operations = parse_operations(options[:where])
  end

  def to_hash
    [:measures, :dimensions, :operations, :orders, :limit, :offset].inject({}) do |result, key|
      result.update key => send(key)
    end
  end

  protected

    # @return [Array] measures + dimensions
    def projections
      measures + dimensions
    end

    # @return [Integer] parsed integer
    def parse_integer(*values)
      options = values.extract_options!
      values.each do |value|
        value = Kernel.Float(value).to_i rescue nil
        return value if value
      end
      options[:default] || 0
    end

    # @return [Integer] parsed integer
    def page_offset(number)
      number = Kernel.Float(number).to_i rescue nil
      (number - 1) * limit if number && number > 0
    end

    # @return [Array] parsed order tuples. Example:
    #   [[#<Projection>, 'ASC'], [#<Projection>, 'DESC'], ... ]
    def parse_orders(value)
      lookup = projections.index_by(&:name)
      normalize_array(value).map do |string|
        name, dir = string.to_s.split('.')
        projection = lookup[name]
        projection ? Fiddle::SortOrder.new(projection, dir) : nil
      end.compact
    end

    # @param [Hash] hash
    # @return [Array] parsed operations
    def parse_operations(hash)
      return [] unless hash.is_a?(Hash)

      lookup = parent.constraints.index_by(&:param_key)
      hash.map do |key, value|
        constraint = lookup[key.sub(/_{2,}/, '.')]
        constraint.operation(value) if constraint
      end.compact
    end

    # @return [Array] parsed collection
    def parse_collection(collection, value, options = {})
      names = normalize_array(value)
      collection.to_a.select {|i| names.include?(i.name) }
    end

end
