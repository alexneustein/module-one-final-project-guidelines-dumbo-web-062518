class User < ActvieRecord::Base
  has_many :ingredients, through: :userpantry
  has_many :drinks, through: :favoritedrink
end
