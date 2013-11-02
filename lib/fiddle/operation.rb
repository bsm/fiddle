class Fiddle::Operation

  # @return [Hash]
  #   registered operations
  def self.registry
    @registry ||= {}
  end

  # Abstract operation
  class Abstract

    # Callback, registers class
    def self.inherited(base)
      parent.registry.update base.code => base
      super
    end

    # Read/declare a label
    def self.label(value = nil)
      @label = value if value
      @label ||= name.demodulize.underscore.gsub('_', ' ')
    end

    # @return [String]
    #   Unique identifier
    def self.code(value = nil)
      @code = value if value
      @code ||= name.demodulize.underscore
    end

    # @return [Fiddle::DataType::Abstract]
    #   Builds a new valid operation, returns nil instead of invalid ones
    def self.force_valid(*a)
      op = new(*a)
      op if op.valid?
    end

    attr_reader :constraint, :value
    delegate    :projection, to: :constraint

    # Constructor
    # @param [Class < Fiddle::DataType::Abstract] type
    # @param [Object] value
    def initialize(constraint, value)
      @constraint = constraint
      @value      = value
    end

    # @return [Class]
    #   Subclass of Fiddle::DataType::Abstract
    def type_class
      projection.type_class
    end

    # @return [Boolean]
    #   Is the given value valid?
    def valid?
      return @is_valid if defined?(@is_valid)
      return false unless type_class.operations.include?(self.class.code)
      @is_valid = sql_args.is_a?(Array) && !sql_args.empty? && sql_args.none?(&:nil?)
    end

    # @return [Array]
    #   the SQL arguments, or nil if invalid
    def sql_args
      @sql_args ||= [type_class.new(value.to_s).convert]
    end

    # @return [String]
    #   the SQL clause
    def sql_clause
      "= ?"
    end

    # @return [Sequel::SQL::PlaceholderLiteralString]
    def where_sql
      Sequel::SQL::PlaceholderLiteralString.new "#{projection.clause} #{sql_clause}", sql_args
    end

  end

  # Collective behaviour
  module Collective
    include Fiddle::Utils

    def sql_args
      result = normalize_array(value).map do |token|
        type_class.new(token).convert
      end
      result.empty? ? [] : [result]
    end

  end

  # Equal operation
  class Eq < Abstract
    label "equal"
  end

  # Not-equal operation
  class NotEq < Abstract
    label "not equal"

    # @return [String]
    #   the SQL clause
    def sql_clause
      "!= ?"
    end
  end

  # Between operation
  class Between < Abstract

    # @return [Array]
    #   with two items
    def sql_args
      normalised = case value
      when ::Range
        [value.first, value.last]
      when /^ *(.+?) *\.{2,} *(.+?) *$/
        [$1, $2]
      else
        value
      end

      normalised.map do |token|
        type_class.new(token.to_s).convert
      end if normalised.is_a?(Array) && normalised.size == 2
    end

    # @return [String]
    def sql_clause
      "BETWEEN ? AND ?"
    end
  end

  # Greater operation
  class Gt < Abstract
    label "greater than"

    # @return [String]
    def sql_clause
      "> ?"
    end
  end

  # Greater-or-equal operation
  class Gteq < Abstract
    label "greater than or equal"

    # @return [String]
    #   the SQL clause
    def sql_clause
      ">= ?"
    end
  end

  # Less operation
  class Lt < Abstract
    label "less than"

    # @return [String]
    def sql_clause
      "< ?"
    end
  end

  # Greater-or-equal operation
  class Lteq < Abstract
    label "less than or equal"

    # @return [String]
    def sql_clause
      "<= ?"
    end
  end

  # In operation
  class In < Abstract
    include Collective

    # @return [String]
    def sql_clause
      "IN ?"
    end
  end

  # Not-in operation
  class NotIn < Abstract
    include Collective

    # @return [String]
    def sql_clause
      "NOT IN ?"
    end
  end

end
