require "active_record"

module NeedleInAHaystack
  # Abstract base for all ActiveRecord models defined by the gem. Kept separate
  # from the host application's own +ApplicationRecord+ so the gem never clashes
  # with (or depends on) the consuming app's base class.
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
