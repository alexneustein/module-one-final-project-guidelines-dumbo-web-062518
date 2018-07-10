class Ingredient < ActiveRecord::Base
  has_many :drinks, through: :drinkingredient
  has_many :users, through: :userpantry
end
