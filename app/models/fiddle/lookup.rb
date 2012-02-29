class Fiddle::Lookup < Fiddle::Base

  # ----> ASSOCIATIONS
  belongs_to :universe

  # ----> VALIDATIONS
  validates_name_alias :scope => :universe_id
  validates :clause,
    :presence => true,
    :length   => { :maximum => 2000 }
  validates :label_clause,
    :presence => true,
    :length   => { :maximum => 255 }
  validates :value_clause,
    :presence => true,
    :length   => { :maximum => 255 }

  # ----> ATTRIBUTES
  attr_accessible :name, :clause, :label_clause, :value_clause

  # ----> INSTANCE METHODS

  # @return [Sequel::LiteralString] the SELECT SQL clause
  def select_sql
    Sequel::LiteralString.new [construct_select(value_clause), construct_select(label_clause)].join(', ')
  end

  # @return [String] the FROM SQL clause
  def from_sql
    [ "( #{clause} )" , name].uniq.join(" AS ")
  end

  #@return [Sequel::LiteralString] the ORDER BY clause
  def order_sql
    Sequel::LiteralString.new "#{label_clause} DESC"
  end

  # @return [Sequel::Dataset]
  def dataset
    universe.conn.dataset.
      select(select_sql).
      from(from_sql).
      order(order_sql)
  end

  private

    def construct_select(col)
      "#{name}.#{col} AS #{col}"
    end

end
