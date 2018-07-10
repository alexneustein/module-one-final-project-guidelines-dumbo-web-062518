class CreateFavoriteDrinks < ActiveRecord::Migration[5.0]
  def change
    create_table :favorite_drinks do |t|
      t.integer :drink_id
      t.integer :user_id
    end
  end
end
