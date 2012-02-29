class Fiddle::Lookup < Fiddle::Base

  # ----> ASSOCIATIONS
  belongs_to :cube

  # ----> VALIDATIONS
  validates_name_alias :scope => :cube_id
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

end
