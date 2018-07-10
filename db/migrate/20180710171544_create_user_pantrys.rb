class CreateUserPantrys < ActiveRecord::Migration[5.0]
  def change
    create_table :user_pantrys do |t|
      t.integer :user_id
      t.integer :ingredient_id
    end
  end
end
