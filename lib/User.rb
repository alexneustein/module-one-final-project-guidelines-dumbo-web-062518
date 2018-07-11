class User < ActiveRecord::Base
  has_many :user_pantries
  has_many :ingredients, through: :user_pantries
  has_many :favorite_drinks
  has_many :drinks, through: :favorite_drinks

  def find_drink(drink_name)
    Drink.find_by(name: drink_name)
  end

  def find_or_create_drink(drink_name)
    Drink.find_or_create_by(name: drink_name)
  end

  def find_ingredient(ingredient_name)
    Ingredient.find_by(name: ingredient_name)
  end

  def find_or_create_ingredient(ingredient_name)
    Ingredient.find_or_create_by(name: ingredient_name)
  end

  def self.id_from_name(name_string)
     return self.find_by(name: name_string).id if self.find_by(name: name_string) != nil
   end

 def create_drink(drink_name)
   Drink.create(name: drink_name)
 end

 def create_ingredient(ingredient_name)

 end
end
