class Drink < ActiveRecord::Base
  has_many :drink_ingredients
  has_many :ingredients, through: :drink_ingredients
  has_many :favoritedrinks
  has_many :users, through: :favoritedrinks
end
