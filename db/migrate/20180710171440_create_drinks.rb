class CreateDrinks < ActiveRecord::Migration[5.0]
  def change
    create_table :drinks do |t|
      t.string :name
      t.string :instructions
      t.integer :drinkingredient_id
    end
  end
end
