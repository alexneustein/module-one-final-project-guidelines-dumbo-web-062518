class CreateDrinkIngredients < ActiveRecord::Migration[5.0]
  def change
    create_table :drinkingredients do |t|
      t.integer :drinkid
      t.integer :ingredientid
    end
  end
end
