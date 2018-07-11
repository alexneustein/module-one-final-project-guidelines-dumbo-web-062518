class DrinkIngredient < ActiveRecord::Base
  belongs_to :drink
  belongs_to :ingredient

  def self.id_from_name(name_string)
     return self.find_by(name: name_string).id if self.find_by(name: name_string) != nil
 end
end
