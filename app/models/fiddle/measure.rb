require 'fiddle/projection'

class Fiddle::Measure < Fiddle::Projection

  # @return [NilClass] always nil
  def group_sql
    nil
  end

end
