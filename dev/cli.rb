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
  name = name.split.map(&:capitalize).join(' ')
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
  user_input = prompt.select("Main Menu:", filter: true) do |menu|
    menu.per_page 17
    menu.choice 'Browse All Drinks', "7"
    if current_user.drinks == []
      menu.choice 'Browse Favorite Drinks'.magenta, "2", disabled: '(no favorite drinks)'.light_magenta
    else
      menu.choice 'Browse Favorite Drinks', "2"
    end
    if current_user.ingredients == []
      menu.choice 'Browse My Pantry'.magenta, "1", disabled: '(empty pantry)'.light_magenta
    else
      menu.choice 'Browse My Pantry', "1"
    end
    menu.choice '———————————————', "i"
    menu.choice 'Find Drink By Name', "3"
    menu.choice 'Find Ingredient By Name', "4"
    menu.choice '———————————————', "i"
    menu.choice 'Add Favorite Drink', "6"
    if current_user.drinks == []
      menu.choice 'Remove Favorite Drink'.magenta, "8", disabled: '(no favorite drinks)'.light_magenta
    else
      menu.choice 'Remove Favorite Drink', "8"
    end
    menu.choice 'What can I make?', "11"
    menu.choice '———————————————', "i"
    menu.choice 'Download New Drink From Web', "10"
    menu.choice 'Create Custom Drink', "12"
    menu.choice '———————————————', "i"
    menu.choice 'Add Ingredient to My Pantry', "5"
    if current_user.ingredients == []
      menu.choice 'Remove Ingredient from Pantry'.magenta, "9", disabled: '(empty pantry)'.light_magenta
    else
      menu.choice 'Remove Ingredient from Pantry', "9"
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
    # current_user.ingredients.each { |ingredient| puts "#{ingredient.name}".cyan }
    puts "____________"
    ingredient_browse = prompt.select('My Ingredients:', per_page: 12, filter: true) do |menu|
      current_user.ingredients.each do |ingredient|
        menu.choice ingredient.name, ingredient.name
      end
    end
    puts "This ingredient is in:"
    find = Ingredient.find_by(name: ingredient_browse)
    ing_count = 1
    find.drinks.each do |drink|
      puts "#{ing_count}. #{drink.name}".cyan
      ing_count += 1
    end
    puts "View one of these drinks? (Y/N)"
    input = gets.chomp.downcase
    if input == 'y' || input == 'yes'
      puts "Which drink are you interested in?"
      drink_browse = prompt.select('Drinks:', filter: true) do |menu|
        find.drinks.each do |drink|
          menu.choice drink.name, drink.name
        end
      end
      drink_profile(current_user, drink_browse)
      actions(current_user)
    else
      actions(current_user)
    end
    actions(current_user)
  elsif user_input == "2"
    box_this_text("Favorite Drinks", "cyan", "yes")
    puts "No Favorite Drinks!".magenta if current_user.drinks == []
    # current_user.drinks.each { |drink| puts "#{drink.name}".cyan }
    # puts "____________"
    drink_browse = prompt.select('Favorite Drinks:', filter: true) do |menu|
      current_user.drinks.each do |drink|
        menu.choice drink.name, drink.name
      end
    end
    drink_profile(current_user, drink_browse)
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
    ingredient_browse = prompt.multi_select("All Ingredients:", filter: true) do |menu|
      menu.per_page 10
      Ingredient.all.each do |ingredient|
        menu.choice ingredient.name, ingredient.name
      end
        # menu.choice 'EXIT', "EXIT"
      end
    # user_input = gets.chomp
    ingredient_browse.each do |ingredient|
      if current_user.ingredients.any? {|a| a.name == ingredient}
        puts "#{ingredient} is already in your pantry!".red
      else
        current_user.ingredients << current_user.find_or_create_ingredient(ingredient)
        puts "Added #{ingredient} to your pantry!".cyan
      end
    end
    puts "Is there anything else you'd like to do?"
    actions(current_user)
  elsif user_input == "6"
    puts "What drink(s) would you like to add?"
    drink_browse = prompt.multi_select("All Drinks:", filter: true) do |menu|
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
    drink_browse = prompt.select("All Drinks:", filter: true) do |menu|
      menu.per_page 10
      Drink.all.each do |drink|
        menu.choice drink.name, drink.name
      end
      # menu.choice 'EXIT', "EXIT"
    end
      drink_profile(current_user, drink_browse)
    elsif user_input == "10"
      box_this_text("Download New Drink", "light_cyan", "yes")

      add_new_drink(search_new_drink)
      puts "__________________________"
      actions(current_user)
    elsif user_input == "12"
      add_custom_drink(cli_create_custom_drink)
      puts "__________________________"
      actions(current_user)
    elsif user_input == "8"
      puts "What drink would you like to remove?"
      drink_browse = prompt.multi_select("All Drinks:", filter: true) do |menu|
        current_user.drinks.each do |drink|
          menu.choice drink.name, drink.name
        end
      end
      drink_browse.each do |drink|
        current_user.delete_fave_drink(drink)
        puts "Removed #{drink} from favorites!".cyan
      end
      puts "__________________________"
      actions(current_user)
  elsif user_input == "9"
    puts "What ingredient(s) would you like to remove?"
    ingredient_browse = prompt.multi_select("All Ingredients:", filter: true) do |menu|
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

  elsif user_input == "11"
    puts "What can I make?"
    compare(current_user.ingredients)
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
    words_hash = {0=>"zero",1=>"one",2=>"two",3=>"three",4=>"four",5=>"five",6=>"six",7=>"seven",8=>"eight",9=>"nine",
                    10=>"ten",11=>"eleven",12=>"twelve"}
    if rejected.count > 0
        puts "Add the #{words_hash[rejected.count]} missing ingredients to your pantry? (Y/N)".yellow
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


# Store an array of arrays (drinks' ingredients)
# new_arr = drink_arr.map {|drink| drink.ingredients}

# Below compares the current_user's ingredient list against a drink's ingredient list
def compare(user_ingredients)
  all_drinks = Drink.all
  drink_ingredients = all_drinks.map {|drink| drink.ingredients }
  count = 0
   if user_ingredients.count == 0
     puts "Unfortunately, you cannot make anything.".red
   elsif user_ingredients.count >= 1
    drink_ingredients.each do |ingredients|
      if user_ingredients == ingredients
        all_drinks.find do |drink| drink.ingredients == ingredients
        puts "You can make: #{drink.name}.".cyan
        end
      elsif user_ingredients != ingredients
        count += 1
      end
  end
  puts "Unfortunately, there are #{count} drinks that you can't make.".red
 end


def search_new_drink
  # Prompts the user to search for a drink and choose from all available hits
  prompt = TTY::Prompt.new(help_color: :cyan) #enable_color: true)
  box_this_text("Download New Drink", "light_cyan", "yes")
  wrapper_hash = {}
  wrapper_hash["drinks"] = nil
  while wrapper_hash["drinks"] == nil
    puts "Search web for drinks:".green
    print "> ".green
    drink_name = gets.chomp.downcase
    drink_name = drink_name.split.map(&:capitalize).join(' ')
    puts "Searching: " + drink_name
    wrapper_hash = get_all_drinks(drink_name)
    if wrapper_hash["drinks"] == nil
      puts "No drinks found!".red
    else
    end
  end
  puts wrapper_hash["drinks"].length.to_s.red + " drink found online!".red if wrapper_hash["drinks"].length <= 1
  puts wrapper_hash["drinks"].length.to_s.cyan + " drinks found online!".cyan if wrapper_hash["drinks"].length > 1
  drink_browse = prompt.select("Select a drink to download:", filter: true) do |menu|
    menu.per_page 10
    wrapper_hash["drinks"].each do |drink|
      menu.choice drink["strDrink"], drink["strDrink"]
    end
      menu.choice "CANCEL", "CANCEL"
  end
  return drink_browse
end


def cli_create_custom_drink
  # Prompts the user to create a new drink and returns hash containing custom entries
  prompt = TTY::Prompt.new(help_color: :cyan) #enable_color: true)
  box_this_text("Create Custom Drink", "light_cyan", "yes")
  #Drink name
  drink_name = "Martini"
  while Drink.all.find_by(name: drink_name) != nil
    puts "Name your drink:".green.underline
    print "> ".green
    drink_name = gets.chomp.downcase
    drink_name = drink_name.split.map(&:capitalize).join(' ')
    if Drink.all.find_by(name: drink_name) != nil
      puts "A duplicate drink name is already in the database!".red
      drink_name = "Martini"
    end
    if drink_name == "" || drink_name == " " || drink_name == "  "
      puts "Invalid name!".red
      drink_name = "Martini"
    end
  end
  #Ingredients
  puts "#{drink_name} contains what ingredients?".green.underline
  ingredient_array = []
  while ingredient_array == []
    ingredient_array = prompt.multi_select("Select at least one ingredient:", filter: true) do |menu|
      Ingredient.all.sort_by {|i| i.name}.each do |ingredient|
        menu.choice ingredient.name, ingredient.name
      end
    end
  end
  puts "Your ingredients: ".magenta + ingredient_array.to_s.light_magenta
  #Instructions
  puts "Preparation instructions:".green.underline
  new_instructions = gets.chomp
  puts "Your instructions: ".magenta + new_instructions.light_magenta
  #Return Hash
  areyousure = prompt.yes?('Are you sure you want to proceed?'.light_blue)
  if areyousure
    custom_drink_hash = {name: drink_name, ingredients: ingredient_array, instructions: new_instructions}
  else
    custom_drink_hash = nil
  end
  custom_drink_hash
end
end
