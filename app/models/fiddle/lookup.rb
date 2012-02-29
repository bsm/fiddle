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
    Sequel::LiteralString.new [build_cause(value_clause, :value), build_cause(label_clause, :label)].join(', ')
  end

  # @return [String] the FROM SQL clause
  def from_sql
    Sequel::LiteralString.new build_cause(clause, name)
  end

  #@return [Sequel::LiteralString] the ORDER BY clause
  def order_sql
    Sequel::LiteralString.new "( #{label_clause} )"
  end

  # @return [Sequel::Dataset]
  def dataset
    universe.conn.dataset.select(select_sql).from(from_sql).order(order_sql)
  end

  private

    def build_cause(value, aliaz)
      "( #{value} ) AS #{aliaz}"
    end

end
