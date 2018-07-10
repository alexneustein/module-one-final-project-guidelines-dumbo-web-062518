class CreateFavoriteDrinks < ActiveRecord::Migration[5.0]
  def change
    create_table :favoritedrinks do |t|
      t.integer :drinkid
      t.integer :userid
    end
  end
end
