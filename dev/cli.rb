require_relative '../config/environment'

# cocktail_array = ["Martini","Manhattan","Old Fashioned","Mint Julep","Mojito","Margarita","Daiquiri","Tom Collins","Martinez","Brandy Cocktail","Brandy Daisy","Sidecar","Whiskey Sour","Sazerac","New Orleans Fizz","French 75","Negroni","Brandy Alexander","Bronx Cocktail"]


def cli_welcome
  puts "Welcome to Access Labs' Cocktail Library!".underline
  puts " "
end

def cli_ask_name
  puts "What is your name?".green
end

def cli_what_to_do
  puts "What would you like to do? (hint: 'i' for instructions)".green
end

def cli_input
  input = ""
  while input == ""
    input = gets.chomp
    puts "Invalid entry! Please try again.".yellow if input == ""
  end
  return input
end

def find_or_create_user(name)
  if User.find_by(name: name) == nil
    puts "Welcome, #{name}!".cyan
  else
    puts "Welcome back, #{name}!".cyan
  end
  User.find_or_create_by(name: name)
end

def actions(current_user)
  prompt = TTY::Prompt.new
  user_input = prompt.select("Main Menu:") do |menu|
    menu.choice 'See My Ingredients', "1"
    menu.choice 'See Favorite Drinks', "2"
    menu.choice 'Find Drink By Name', "3"
    menu.choice 'Browse All Drinks', "7"
    menu.choice 'Find Ingredient By Name', "4"
    menu.choice 'Add Ingredient to Pantry', "5"
    menu.choice 'Add Favorite Drink', "6"
    menu.choice 'EXIT', "EXIT"
  end
  if user_input == "i"
    user_input = prompt.select("Main Menu:") do |menu|
      menu.choice 'See My Ingredients', "1"
      menu.choice 'See Favorite Drinks', "2"
      menu.choice 'Find Drink By Name', "3"
      menu.choice 'Browse All Drinks', "7"
      menu.choice 'Find Ingredient By Name', "4"
      menu.choice 'Add Ingredient to Pantry', "5"
      menu.choice 'Add Favorite Drink', "6"
      menu.choice 'EXIT', "EXIT"
    end
    actions(current_user)
  elsif user_input == "1"
    current_user.ingredients.each { |ingredient| puts "#{ingredient.name}".cyan }
    puts "Is there anything else you'd like to do?".green
    actions(current_user)
  elsif user_input == "2"
    current_user.drinks.each { |drink| puts "#{drink.name}" }
    puts "Is there anything else you'd like to do?"
    actions(current_user)
  elsif user_input == "3"
    puts "Which drink are you looking for?"
    drink_name = gets.chomp
    if current_user.find_drink(drink_name)
      counter = 1
      drink_ingredients = current_user.find_drink_ingredients(drink_name)
      find = current_user.find_drink(drink_name)
      puts "#{find.name} exists! Here are the instructions: "
      puts "#{find.instructions}"
      drink_ingredients.each do |ingredient|
        puts "#{counter}. #{ingredient.name}"
        counter += 1
      end
      actions(current_user)
    else
      puts "This drink doesn't exist in your favorites!"
      puts "Is there anything else you'd like to do?"
      actions(current_user)
    end
  elsif user_input == "4"
    puts "Which ingredient are you looking for?"
    ingredient_name = gets.chomp
    if current_user.find_ingredient(ingredient_name)
      ingredient = current_user.find_ingredient(ingredient_name)
      puts "#{ingredient.name} exists!"
      puts "Is there anything else you'd like to do?"
      actions(current_user)
    else
      puts "This ingredient doesn't exist in your pantry!"
      puts "Is there anything else you'd like to do?"
      actions(current_user)
    end
  elsif user_input == "5"
    puts "What ingredient would you like to add?"
    user_input = gets.chomp
    current_user.ingredients << current_user.find_or_create_ingredient(user_input)
    puts "Success!"
    puts "Is there anything else you'd like to do?"
    actions(current_user)
  elsif user_input == "6"
    puts "What drink would you like to add?"
    user_input = gets.chomp
    current_user.drinks << current_user.find_or_create_drink(user_input)
    puts "Success!"
    puts "Is there anything else you'd like to do?"
    actions(current_user)
  elsif user_input == "7"
    drink_browse = prompt.select("All Drinks:") do |menu|
      Drink.all.each do |drink|
        menu.choice drink.name, drink.id
      end
      menu.choice 'EXIT', "EXIT"
    end
    # binding.pry
    if drink_browse != "exit"
      find = current_user.find_by_id(drink_browse)
      puts "#{find.name} exists! Here are the instructions: "
      puts "#{find.instructions}"
      counter = 1
      find.ingredients.each do |ingredient|
          puts "#{counter}. #{ingredient.name}"
          counter += 1
      end
      actions(current_user)
    end
      puts "Is there anything else you'd like to do?"
      actions(current_user)
  elsif user_input == "EXIT" || user_input == "exit" || user_input == "QUIT" || user_input == "quit"
    exit
  else
    puts "Command not recognized. Please try again:"
    actions(current_user)
  end
end
