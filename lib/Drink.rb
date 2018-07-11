class Drink < ActiveRecord::Base
  has_many :drink_ingredients
  has_many :ingredients, through: :drink_ingredients
  has_many :favoritedrinks
  has_many :users, through: :favoritedrinks

  def self.id_from_name(name_string)
     return self.find_by(name: name_string).id if self.find_by(name: name_string) != nil
 end
end
