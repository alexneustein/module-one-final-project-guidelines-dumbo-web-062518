class Ingredient < ActiveRecord::Base
  has_many :drink_ingredients
  has_many :drinks, through: :drink_ingredients
  has_many :user_pantries
  has_many :users, through: :user_pantries

  def self.id_from_name(name_string)
     return self.find_by(name: name_string).id if self.find_by(name: name_string) != nil
 end
end
