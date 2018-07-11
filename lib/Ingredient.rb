class Ingredient < ActiveRecord::Base
  has_many :drink_ingredients
  has_many :drinks, through: :drink_ingredients
  has_many :user_pantrys
  has_many :users, through: :user_pantrys

  def self.id_from_name(name_string)
    self.find_by(name: name_string).id
  end
end
