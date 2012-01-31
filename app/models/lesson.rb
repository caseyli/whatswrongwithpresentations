class Lesson < ActiveRecord::Base
 
  default_scope order("category", "orderby")
  scope :lessons_only, order("category", "orderby").where("not category='0'")

end
