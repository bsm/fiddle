class Fiddle::Lookup < Fiddle::Base

  # ----> ASSOCIATIONS
  belongs_to :universe

  # ----> VALIDATIONS
  validates_name_alias scope: :universe_id
  validates :clause,
    presence: true,
    length: { maximum: 2000 }
  validates :label_clause, :value_clause,
    presence: true,
    length: { maximum: 255 }
  validates :parent_value_clause,
    length: { maximum: 255 }

  # ----> INSTANCE METHODS

  # @return [Sequel::LiteralString] the SELECT SQL clause
  def select_sql
    Sequel::LiteralString.new [
      build_clause(value_clause, :value, " AS "),
      build_clause(label_clause, :label, " AS "),
      build_clause(parent_value_clause, :parent_value, " AS ")
    ].compact.join(', ')
  end

  # @return [String] the FROM SQL clause
  def from_sql
    Sequel::LiteralString.new build_clause(clause, name)
  end

  #@return [Sequel::LiteralString] the ORDER BY clause
  def order_sql
    Sequel::LiteralString.new "label"
  end

  # @return [Sequel::Dataset]
  def dataset
    @dataset ||= universe.conn.dataset.select(select_sql).from(from_sql).order(order_sql)
  end

  private

    def build_clause(value, aliaz, connector = ' ')
      return nil unless value.present?
      [value, aliaz].compact.uniq.join(connector)
    end

end
