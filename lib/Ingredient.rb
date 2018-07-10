class Ingredient < ActiveRecord::Base
  has_many :drink_ingredients
  has_many :drinks, through: :drink_ingredients
  has_many :user_pantrys
  has_many :users, through: :user_pantrys
end
