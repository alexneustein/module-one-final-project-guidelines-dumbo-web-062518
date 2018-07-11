class FavoriteDrink < ActiveRecord::Base
  belongs_to :user
  belongs_to :drink

  def self.id_from_name(name_string)
     return self.find_by(name: name_string).id if self.find_by(name: name_string) != nil
 end
end
