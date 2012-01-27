class Lesson < ActiveRecord::Base

  default_scope order("category", "orderby")

end
