module Fiddle::DataType

  # @return [Hash]
  #   registered data types
  def self.registry
    @registry ||= {}
  end

  # Abstract data type
  class Abstract < ::String

    # Callback, registers data type
    def self.inherited(base)
      parent.registry.update base.code => base
      super
    end

    # @param [multiple] *codes
    #   Provide codes to add more operations
    # @return [Array]
    #   Valid operations
    def self.operations(*codes)
      @operations ||= (self == Abstract ? [] : superclass.operations.dup)
      @operations += Fiddle::Operation.registry.keys & codes unless codes.empty?
      @operations
    end

    # @return [String]
    #   Unique data type identifier
    def self.code
      name.demodulize.underscore
    end

    # Convert input to comparison value
    # @return [String]
    def convert
      to_s.presence
    end

    def numeric?
      !!Float(self) rescue nil
    end

  end

  # String data type
  class String < Abstract
    operations "eq", "not_eq", "in", "not_in"
  end

  # Numeric data type
  class Numeric < Abstract
    operations "eq", "not_eq", "in", "not_in", "gt", "lt", "gteq", "lteq", "between"

    # @return [Float]
    def convert
      Float(self) rescue nil
    end

  end

  # Integer data type
  class Integer < Numeric

    # @return [Integer]
    def convert
      super.try(:to_i)
    end

  end

  # Datetime data type
  class Datetime < Abstract
    operations "gt", "lt", "gteq", "lteq", "between"

    # @return [Time]
    def convert
      if numeric?
        to_i.from_now.utc
      else
        to_time(:utc) rescue nil
      end
    end

  end

  class Date < Abstract
    operations "eq", "not_eq", "gt", "lt", "gteq", "lteq", "between"

    # @return [Date]
    def convert
      if numeric?
        to_i.days.from_now.to_date
      else
        to_date rescue nil
      end
    end

  end
end
