class User < ActiveRecord::Base
  has_many :user_pantrys
  has_many :ingredients, through: :user_pantrys
  has_many :favorite_drinks
  has_many :drinks, through: :favorite_drinks
end
