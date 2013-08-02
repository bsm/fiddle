require 'sequel/core'

class Fiddle::Cube < Fiddle::Base

  # ---> ASSOCIATIONS
  belongs_to :universe
  has_many   :relations, dependent: :destroy
  has_many   :projections, dependent: :destroy
  has_many   :dimensions
  has_many   :measures
  has_many   :constraints

  # ---> VALIDATIONS
  validates_name_alias scope: :universe_id
  validates :universe, presence: true
  validates :clause,
    presence: true,
    length:   { maximum: 2000 }

  # @return [Array] list of table aliases used inside this cube
  def table_aliases
    @table_aliases ||= [name] + relations.select(:name).map(&:name)
  end

  # @return [Sequel::Dataset]
  def dataset
    @dataset ||= universe.conn.dataset
  end

  # @return [String] the FROM SQL clause
  def from_sql
    [clause, name].uniq.join(" AS ")
  end

  # @param [Hash] options
  #   please see Fiddle::ParamParser#initialize for details
  # @return [Fiddle::ParamParser]
  #   the param parser object
  def parse(options = {})
    Fiddle::ParamParser.new(self, params)
  end

  # @param [Hash] options
  #   please see Fiddle::SQLBuilder#initialize for details
  # @return [String]
  #   the generated SQL
  def to_sql(options = {})
    Fiddle::SQLBuilder.new(self, options).to_s
  end

end
