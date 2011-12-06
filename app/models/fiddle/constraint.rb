class Fiddle::Constraint < Fiddle::Base

  # ---> ASSOCIATIONS
  belongs_to :cube
  belongs_to :projection

  # ---> VALIDATIONS
  validates_name_alias :scope => [:cube_id, :operation_code]
  validates :cube, :projection_id, :projection, :presence => true
  validates :operation_code,
    :presence   => true,
    :inclusion  => { :in => Fiddle::Operation.registry.keys, :allow_blank => true }
  validate  :ensure_correct_operation_code
  validate  :ensure_projection_matches_cube

  # ---> ATTRIBUTES
  attr_accessible :name, :projection_id, :operation_code

  # @return [Class] the operation class
  def operation_class
    Fiddle::Operation.registry[operation_code]
  end

  # @param [String] comparison value
  # @return [Fiddle::Operation::Abstract] operation instance
  def operation(value)
    operation_class.force_valid(self, value) if operation_class
  end

  # @return [String]
  #   The parameter key for this constraint. Example: "website.eq"
  def param_key
    [name, operation_code].join('.')
  end

  private

    def ensure_correct_operation_code
      return unless projection.try(:type_class) && operation_code
      errors.add :operation_code, :not_applicable unless projection.type_class.operations.include?(operation_code)
    end

    def ensure_projection_matches_cube
      return unless cube && projection
      errors.add :projection_id, :invalid unless cube.id == projection.cube_id
    end

end
