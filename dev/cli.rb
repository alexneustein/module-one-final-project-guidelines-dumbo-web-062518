require_relative '../config/environment'

# cocktail_array = ["Martini","Manhattan","Old Fashioned","Mint Julep","Mojito","Margarita","Daiquiri","Tom Collins","Martinez","Brandy Cocktail","Brandy Daisy","Sidecar","Whiskey Sour","Sazerac","New Orleans Fizz","French 75","Negroni","Brandy Alexander","Bronx Cocktail"]


def cli_welcome
  system("clear")
  asciiart = Artii::Base.new :font => 'roman'
  puts " "
  30.times {print " "}
  puts "Welcome to Access Labs'".underline
  puts " "
  puts asciiart.asciify("Cocktail").light_blue
  puts asciiart.asciify("Library").light_blue
end

def cli_ask_name
  puts "What is your name?".green
  print "> ".green
end

def cli_what_to_do
  puts "What would you like to do?".green
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
  asciiart = Artii::Base.new :font => 'roman'
  prompt = TTY::Prompt.new(help_color: :cyan) #enable_color: true)
  user_input = prompt.select("Main Menu:") do |menu|
    menu.per_page 14
    menu.choice 'Browse All Drinks', "7"
    if current_user.drinks == []
      menu.choice 'See Favorite Drinks'.magenta, "2", disabled: '(no favorite drinks)'.light_magenta
    else
      menu.choice 'See Favorite Drinks', "2"
    end
    if current_user.ingredients == []
      menu.choice 'See My Ingredients'.magenta, "1", disabled: '(empty pantry)'.light_magenta
    else
      menu.choice 'See My Ingredients Pantry', "1"
    end
    menu.choice '———————————————', "i"
    menu.choice 'Find Drink By Name', "3"
    menu.choice 'Find Ingredient By Name', "4"
    menu.choice '———————————————', "i"
    menu.choice 'Add Ingredient to Pantry', "5"
    if current_user.ingredients == []
      menu.choice 'Remove Ingredient from Pantry'.magenta, "9", disabled: '(empty pantry)'.light_magenta
    else
      menu.choice 'Remove Ingredient from Pantry', "9"
    end
    menu.choice '———————————————', "i"
    menu.choice 'Add Favorite Drink', "6"
    if current_user.drinks == []
      menu.choice 'Remove Favorite Drink'.magenta, "8", disabled: '(no favorite drinks)'.light_magenta
    else
      menu.choice 'Remove Favorite Drink', "8"
    end
    menu.choice '———————————————', "i"
    menu.choice 'EXIT', "EXIT"
  end
  if user_input == "i"
    # user_input = prompt.select("Main Menu:") do |menu|
    #   menu.per_page 10
    #   menu.choice 'See My Ingredients', "1"
    #   menu.choice 'See Favorite Drinks', "2"
    #   menu.choice 'Find Drink By Name', "3"
    #   menu.choice 'Browse All Drinks', "7"
    #   menu.choice 'Find Ingredient By Name', "4"
    #   menu.choice 'Add Ingredient to Pantry', "5"
    #   menu.choice 'Add Favorite Drink', "6"
    #   menu.choice 'Remove Favorite Drink', "8"
    #   menu.choice 'Remove Pantry Ingredient', "9"
    #   menu.choice 'EXIT', "EXIT"
    # end
    actions(current_user)
  elsif user_input == "1"
    box_this_text("My Pantry", "cyan", "yes")
    puts "Empty Pantry!".magenta if current_user.ingredients == []
    current_user.ingredients.each { |ingredient| puts "#{ingredient.name}".cyan }
    puts "____________"
    actions(current_user)
  elsif user_input == "2"
    box_this_text("Favorite Drinks", "cyan", "yes")
    puts "No Favorite Drinks!".magenta if current_user.drinks == []
    current_user.drinks.each { |drink| puts "#{drink.name}".cyan }
    puts "____________"
    actions(current_user)
  elsif user_input == "3"
    puts "Which drink are you looking for?"
    drink_name = gets.chomp.capitalize
    drink_profile(current_user, drink_name)
  elsif user_input == "4"
    puts "Which ingredient are you looking for?"
    ingredient_name = gets.chomp.capitalize
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
    ingredient_browse = prompt.multi_select("All Ingredients:") do |menu|
      menu.per_page 10
      Ingredient.all.each do |ingredient|
        menu.choice ingredient.name, ingredient.name
      end
        # menu.choice 'EXIT', "EXIT"
      end
    # user_input = gets.chomp
    ingredient_browse.each do |ingredient|
      if current_user.ingredients.any? {|a| a.name == ingredient}
        puts "#{ingredient} is already in pantry!".red
      else
        current_user.ingredients << current_user.find_or_create_ingredient(ingredient)
        puts "Added #{ingredient} to pantry!".cyan
      end
    end
    puts "Is there anything else you'd like to do?"
    actions(current_user)
  elsif user_input == "6"
    puts "What drink(s) would you like to add?"
    drink_browse = prompt.multi_select("All Drinks:") do |menu|
      menu.per_page 10
      Drink.all.each do |drink|
        menu.choice drink.name, drink.name
      end
      # menu.choice 'EXIT', "EXIT"
    end
    # user_input = gets.chomp
    drink_browse.each do |drink|
      if current_user.drinks.any? {|a| a.name == drink}
        puts "#{drink} is already in favorites!".red
      else
        current_user.drinks << current_user.find_or_create_drink(drink)
        puts "Added #{drink} to favorites!".cyan
      end
    end
    puts "Is there anything else you'd like to do?"
    actions(current_user)
  elsif user_input == "7"
    drink_browse = prompt.select("All Drinks:") do |menu|
      menu.per_page 10
      Drink.all.each do |drink|
        menu.choice drink.name, drink.name
      end
      # menu.choice 'EXIT', "EXIT"
    end
      drink_profile(current_user, drink_browse)
    elsif user_input == "8"
      puts "What drink would you like to remove?"
      drink_browse = prompt.multi_select("All Drinks:") do |menu|
        current_user.drinks.each do |drink|
          menu.choice drink.name, drink.name
        end
      end
      drink_browse.each do |drink|
        current_user.delete_fave_drink(drink)
        puts "Removed #{drink} from favorites!".cyan
      end
      puts "__________________________\nIs there anything else you'd like to do?"
      actions(current_user)
  elsif user_input == "9"
    puts "What ingredient(s) would you like to remove?"
    ingredient_browse = prompt.multi_select("All Ingredients:") do |menu|
      current_user.ingredients.each do |ingredient|
        menu.choice ingredient.name, ingredient.name
      end
    end
    ingredient_browse.each do |ingredient|
      current_user.delete_pantry_ingredient(ingredient)
      puts "Removed #{ingredient} from pantry!".cyan
    end
    puts "Is there anything else you'd like to do?"
    actions(current_user)
  elsif user_input == "EXIT" || user_input == "exit" || user_input == "QUIT" || user_input == "quit"
    system("clear")
    puts "Thanks for using the Access Labs Cocktail Library!"
    puts "Always drink responsibly. Never drink and drive.".magenta
    exit
  else
    puts "Command not recognized. Please try again:"
    actions(current_user)
  end
end

def drink_profile(current_user, drink_name)
  asciiart = Artii::Base.new :font => 'roman'
  prompt = TTY::Prompt.new
  system("clear")
  if current_user.find_drink(drink_name)
    find = current_user.find_drink(drink_name)
    drink_title = asciiart.asciify("#{find.name}")
    box_this_text("Drink Profile", "cyan")
    print "╔"
    (drink_title.split("\n")[0].length).times { print "═"}
    puts "╗"
    puts asciiart.asciify("#{find.name}").light_cyan
    print "╚"
    (drink_title.split("\n")[0].length).times { print "═"}
    puts "╝"
    puts "FAVORITE DRINK".light_magenta if current_user.isFavorite?(drink_name)
    puts ""
    box_this_text("Ingredients", "cyan", "yes")
    drink = Drink.find_by(name: drink_name)
    drink_ingredients = drink.ingredients
    # ingredient_browse = prompt.select("Ingredients:") do |menu|
    #   drink_ingredients.all.each do |ingredient|
    #     menu.choice ingredient.name, ingredient.name
    #   end
    #   menu.choice 'EXIT', "EXIT"
    # end
    counter = 1
    drink_ingredients.each do |ingredient|
      #ingredient.name ==
      puts "#{counter}. #{ingredient.name}"
      counter += 1
    end
    puts ""
    user_ingredients = current_user.ingredients
    rejected = drink_ingredients.reject {|ingredient| user_ingredients.include? ingredient}
    rej_count = 1
    puts "Missing Ingredients".yellow.underline if rejected != []
    rejected.each do |missing|
      puts "#{rej_count}. #{missing.name}"
      rej_count += 1
    end
    puts ""
    box_this_text("Instructions", "cyan", "yes")
    puts "#{find.instructions}"
    puts ""
    if rejected.count > 0
        puts "Do you wish to add the missing ingredients to your pantry? (Y/N)"
        input = gets.chomp.downcase
      if input == 'y' || input == "yes"
        rejected.each do |ingredient|
          current_user.ingredients << current_user.find_or_create_ingredient(ingredient.name)
          puts "Added #{ingredient.name} to your pantry!".cyan
        end
        actions(current_user)
    else
      actions(current_user)
    end
  end
  actions(current_user)
  else
    puts "This drink doesn't exist in your favorites!"
    puts "Is there anything else you'd like to do?"
    actions(current_user)
  end
end

def box_this_text(string, color, bottom="no")
  print "╔═"
  (string.length).times { print "═"}
  puts "═╗"
  puts "║ " + string.send(color) + " ║"
  if bottom == "yes"
    print "╚═"
    (string.length).times { print "═"}
    puts "═╝"
  end
end
