require_relative '../config/environment'

# cocktail_array = ["Martini","Manhattan","Old Fashioned","Mint Julep","Mojito","Margarita","Daiquiri","Tom Collins","Martinez","Brandy Cocktail","Brandy Daisy","Sidecar","Whiskey Sour","Sazerac","New Orleans Fizz","French 75","Negroni","Brandy Alexander","Bronx Cocktail"]

def cli_welcome
  puts "Welcome to Access Labs' Cocktail Library!"
  puts "-----------------------------------------"
end

def cli_ask_name
  puts "What is your name?"
end

def cli_what_to_do
  puts "What would you like to do? (hint: 'i' for instructions)"
end

def cli_input
  input = ""
  while input == ""
    input = gets.chomp
    puts "Invalid entry! Please try again." if input == ""
  end
  return input
end

def find_or_create_user(name)
  if User.find_by(name: name) == nil
    puts "Welcome, #{name}!"
  else
    puts "Welcome back, #{name}!"
  end
  User.find_or_create_by(name: name)
end

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
      counter = 1
      drink_ingredients = current_user.find_drink_ingredients(drink_name)
      find = current_user.find_drink(drink_name)
      puts "#{find.name} exists! Here are the instructions: "
      puts "#{find.instructions}"
      ingredient_names = drink_ingredients.each do |ingredient|
        puts "#{counter}. #{ingredient.name}"
        counter += 1
      end
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
  elsif user_input == "Add Ingredient"
    puts "What ingredient would you like to add?"
    user_input = gets.chomp
    current_user.ingredients << current_user.find_or_create_ingredient(user_input)
    puts "Success!"
    puts "Is there anything else you'd like to do?"
    user_input = gets.chomp
    actions(user_input, current_user)
  elsif user_input == "Add Drink"
    puts "What drink would you like to add?"
    user_input = gets.chomp
    current_user.drinks << current_user.find_or_create_drink(user_input)
    puts "Success!"
    puts "Is there anything else you'd like to do?"
    user_input = gets.chomp
    actions(user_input, current_user)
  elsif user_input == "EXIT" || user_input == "exit" || user_input == "QUIT" || user_input == "quit"
    exit
  else
    puts "Command not recognized. Please try again:"
    user_input = gets.chomp
    actions(user_input, current_user)
  end
end
