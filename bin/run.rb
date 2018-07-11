require_relative '../config/environment'



puts "Welcome to Access Labs' Cocktail Library!"
puts "-----------------------------------------"
puts "What is your name?"
name = gets.chomp
def find_user(name)
  User.find_by(name: name)
end

current_user = find_user(name)

puts "What would you like to do? (hint: 'i' for instructions)"
user_input = gets.chomp

# Create helper method for 'is there anything else?'

# def continue?
#   puts "Is there anything else you'd like to do?"
#   user_input = gets.chomp
# end

def actions(user_input, current_user)
  if user_input == "i"
    puts "See Pantry: Check Ingredients"
    puts "See Favorite Drinks: Check Drinks"
    puts "Find Specific Drink: Find Drink"
    puts "Find Specific Ingredient: Find Ingredient"
    puts "Add Ingredient to Pantry: Add Ingredient"
    puts "Add Favorite Drink: Add Drink"
    puts "Leave: EXIT"
    user_input = gets.chomp
    actions(user_input, current_user)
  elsif user_input == "Check Ingredients"
    current_user.ingredients.each { |ingredient| puts "#{ingredient.name}" }
    puts "Is there anything else you'd like to do?"
    user_input = gets.chomp
    actions(user_input, current_user)
  elsif user_input == "Check Drinks"
    current_user.drinks.each { |drink| puts "#{drink.name}" }
    puts "Is there anything else you'd like to do?"
    user_input = gets.chomp
    actions(user_input, current_user)
  elsif user_input == "Find Drink"
    puts "Which drink are you looking for?"
    drink_name = gets.chomp
    if current_user.find_drink(drink_name)
      find = current_user.find_drink(drink_name) #.each {|drink| puts "#{drink_name} exists! Here are the Instructions: #{drink.instructions}"}
      puts "#{find.name} exists! Here are the instructions: "
      puts "#{find.instructions}"
      puts "Is there anything else you'd like to do?"
      user_input = gets.chomp
      actions(user_input, current_user)
    else
      puts "This drink doesn't exist in your favorites!"
      puts "Is there anything else you'd like to do?"
      user_input = gets.chomp
      actions(user_input, current_user)
    end
  elsif user_input == "Find Ingredient"
    puts "Which ingredient are you looking for?"
    ingredient_name = gets.chomp
    if current_user.find_ingredient(ingredient_name)
      ingredient = current_user.find_ingredient(ingredient_name)
      puts "#{ingredient.name} exists!"
      puts "Is there anything else you'd like to do?"
      user_input = gets.chomp
      actions(user_input, current_user)
    else
      puts "This ingredient doesn't exist in your pantry!"
      puts "Is there anything else you'd like to do?"
      user_input = gets.chomp
      actions(user_input, current_user)
    end
  end
end



actions(user_input, current_user)



# User database
# andre = User.create(name: "Andre", password: "2kool4skool")
# alex = User.create(name: "Alex", password: "iter8r")
