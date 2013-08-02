require 'fiddle/projection'

class Fiddle::Dimension < Fiddle::Projection

  # ---> ATTRIBUTES
  attr_accessible :visible if Fiddle.protected_attributes?

end
