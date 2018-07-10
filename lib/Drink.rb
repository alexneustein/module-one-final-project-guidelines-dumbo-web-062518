class Drink < ActiveRecord::Base
  has_many :ingredients, through: :drinkingredient
  has_many :users, through: :favoritedrink
end
