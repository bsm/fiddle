class Fiddle::Relation < Fiddle::Base
  OPERATORS = ["INNER JOIN", "LEFT OUTER JOIN", "RIGHT OUTER JOIN"].freeze

  # ---> ASSOCIATIONS
  belongs_to :cube

  # ---> VALIDATIONS
  validates_name_alias scope: :cube_id
  validates :cube, presence: true
  validates :predicate, :target,
    :presence   => true,
    :length     => { maximum: 2000 }
  validates :operator,
    :presence   => true,
    :inclusion  => { in: OPERATORS, allow_blank: true }
  validate  :ensure_name_is_not_clashing_with_cube

  # @return [String] the full join SQL clause
  def join_sql
    return "" unless [operator, target, name, predicate].all?(&:present?)
    [operator, target, "AS #{name}", "ON", predicate].join(" ")
  end

  private

    def ensure_name_is_not_clashing_with_cube
      errors.add :name, :taken if name.present? && name == cube.try(:name)
    end

end
