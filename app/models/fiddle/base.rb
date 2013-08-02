class Fiddle::Base < ActiveRecord::Base
  self.abstract_class = true

  def self.validates_name_alias(options = {})
    validates :name,
      presence:   true,
      length:     { maximum: 30 },
      format:     { with: Fiddle::REGEXP, allow_blank: true },
      uniqueness: options.merge(case_sensitive: false, allow_blank: true)
  end

end
