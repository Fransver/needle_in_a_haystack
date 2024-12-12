# A minimal taggable model used only by the test suite. Backed by the `widgets`
# table defined in db/schema.rb.
class Widget < ActiveRecord::Base
  include NeedleInAHaystack::Taggable
end
