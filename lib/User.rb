class User < ActiveRecord::Base
  has_many :ingredients, through: :userpantry
  has_many :drinks, through: :favoritedrink
end
