class Fiddle::Projection < Fiddle::Base

  # ---> ASSOCIATIONS
  belongs_to :cube
  has_many :constraints, :dependent => :destroy

  # ---> VALIDATIONS
  validates_name_alias :scope => :cube_id
  validates :cube, :presence => true
  validates :description, :length => { :maximum => 80 }
  validates :clause,
    :presence   => true,
    :length     => { :maximum => 255 }
  validates :clause,
    :length     => { :maximum => 255 }
  validates :type_code,
    :presence   => true,
    :inclusion  => { :in => Fiddle::DataType.registry.keys, :allow_blank => true }
  validate  :ensure_references_match

  # ---> ATTRIBUTES
  attr_accessible :name, :clause, :sortable, :type_code

  # @return [Fiddle::DataType] the assocaited data type
  def type_class
    Fiddle::DataType.registry[type_code]
  end

  # @return [String] the SELECT SQL clause
  def select_sql
    [clause, name].uniq.join(" AS ")
  end

  # @return [String] the GROUP SQL clause
  def group_sql
    clause
  end

  # @return [Array] matched table references
  def references
    Fiddle.references(clause)
  end

  private

    def ensure_references_match
      return unless cube

      missing = references - cube.table_aliases
      errors.add :clause, :invalid_reference, :missing => missing.to_sentence unless missing.empty?
    end

end
