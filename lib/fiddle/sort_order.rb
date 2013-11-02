class Fiddle::SortOrder
  DESC_VALUES = ['1', 1, 'd', 'desc', 'DESC', 'D', 'dsc', 'DSC'].to_set

  attr_reader :projection, :direction

  def initialize(projection, direction)
    @projection, @direction = projection, (DESC_VALUES.include?(direction) ? "DESC" : "ASC")
  end

  def order_sql
    [projection.name, direction].join(" ")
  end
  alias_method :to_s, :order_sql

  def ==(other)
    super || (other.is_a?(String) && to_s == other)
  end

end
