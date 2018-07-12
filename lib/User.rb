class User < ActiveRecord::Base
  has_many :user_pantries
  has_many :ingredients, through: :user_pantries
  has_many :favorite_drinks
  has_many :drinks, through: :favorite_drinks
#  validates_uniqueness_of :user_pantries, scope: [:user_id, :ingredient_id]

  def find_drink(drink_name)
    Drink.find_by(name: drink_name)
  end

  def find_by_id(drink_id)
    Drink.find_by(id: drink_id)
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

  def find_drink_ingredients(drink_name)
    Drink.find_by(name: drink_name).ingredients
  end

  def isFavorite?(drink_name)
    self.drinks.find_by(name: drink_name) ? true : false
  end

  def delete_fave_drink(drink_name)
    found = self.find_drink(drink_name)
    self.drinks.delete(found)
  end

  def delete_pantry_ingredient(ingredient_name)
    found = self.find_ingredient(ingredient_name)
    self.ingredients.delete(found)
  end

end
