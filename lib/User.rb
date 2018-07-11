class User < ActiveRecord::Base
  has_many :user_pantries
  has_many :ingredients, through: :user_pantries
  has_many :favorite_drinks
  has_many :drinks, through: :favorite_drinks
end
