require 'rest-client'
require 'json'
require 'pry'
# These methods are used to scrape the drink instructions and ingredients from the cocktail DB site.


def get_drink_hash(drink)
  #takes a drink name and downloads and returns the first matching drink hash
  all_drinks = RestClient.get('https://www.thecocktaildb.com/api/json/v1/1/search.php?s=' + drink.to_s)
  wrapper_hash = JSON.parse(all_drinks)
  wrapper_hash["drinks"].kind_of?(Array) ? drink_hash = wrapper_hash["drinks"][0] : drink_hash = wrapper_hash["drinks"]
end

def get_all_drinks(drink)
  #takes a drink name and downloads all matching drink hashes
  all_drinks = RestClient.get('https://www.thecocktaildb.com/api/json/v1/1/search.php?s=' + drink.to_s)
  wrapper_hash = JSON.parse(all_drinks)
end

def get_ingredients(drink_hash)
  # Takes a downloaded drink_hash and returns a an array of ingredients.
  return [] if drink_hash == nil
  ingredient_array = []
  loop_counter = 1
  until loop_counter == 16
    break if drink_hash["strIngredient#{loop_counter}"] == ""
    ingredient_array << drink_hash["strIngredient#{loop_counter}"]
    loop_counter += 1
  end
  return ingredient_array
end

def get_instructions(drink_hash)
  # Takes a downloaded drink_hash and returns a string containing recipe instructions.
  return "" if drink_hash == nil
  instruction_string = drink_hash["strInstructions"]
end

def get_ingredients_from_drink_names(drink_names_array)
  combined_ingredient_array = []
  drink_names_array.each do |drink_name|
    combined_ingredient_array << get_ingredients(get_drink_hash(drink_name)).compact
    combined_ingredient_array = combined_ingredient_array.flatten
    combined_ingredient_array = combined_ingredient_array.uniq
  end
  combined_ingredient_array
end

def ingredient_add(ingredient_array)
  # Takes an array of ingredients, and creates database entries of the ingredients.
  ingredient_array.each do |ingredient|
    Ingredient.find_or_create_by(name: ingredient)
  end
end

def ingredient_bulk_seed(drink_names_array)
  # Takes an array of drink names, finds the drink's ingredients, and creates database entries of the ingredients.
  master_list_array = get_ingredients_from_drink_names(drink_names_array)
  ingredient_add(master_list_array)
end

def build_drinks_and_instructions(drink_names_array)
# Takes an array of drink names and returns a hash comprising the drink name and the recipe instructions.
  master_drinks_hash = {}
  drink_names_array.each do |drink_name|
    master_drinks_hash[drink_name] = get_instructions(get_drink_hash(drink_name))
  end
  master_drinks_hash
end

def drink_and_instruction_seed(drink_names_array)
  # Takes an array of drink names and creates database entries containing the drink name and the recipe instructions.
  master_drinks_hash = build_drinks_and_instructions(drink_names_array)
  master_drinks_hash.each do |key, value|
    Drink.find_or_create_by(name: key, instructions: value)
  end
end

def get_drink_id_and_ingredient_ids(drink_name_string, ingredient_array=[])
# Takes a drink name string and returns an id_hash containing the drink ID and an array of the ingredient IDs.
# Get the drink id from the database
  drink_id = Drink.id_from_name(drink_name_string)
# Get the ingredients from the website if empty
  if ingredient_array == []
    ingredient_array = get_ingredients(get_drink_hash(drink_name_string))
  end
# Get the ingredient ids from the database
  ingredient_ids = []
  ingredient_array.each do |ingredient|
    ingredient_ids << Ingredient.id_from_name(ingredient)
  end
  return {table1_id: drink_id, table2_ids: ingredient_ids}
end

def make_joiner_entries(table1, table2, id_hash)
  # creates association entries in the joiner table between the table 1 ID and the table 2 IDs
  # id_hash MUST BE in the following format: {:table1_id=>1, :table2_ids=>[1, 2, 3]}
  id_hash[:table2_ids].each do |table2_id|
    table2s = table2.name.downcase.pluralize
    if table1.find_by(id: id_hash[:table1_id]).send(table2s).find {|i| i.id == table2_id} == nil
    #  puts "Creating new association!"
      table1.find_by(id: id_hash[:table1_id]).send(table2s) << table2.find_by(id: table2_id)
    else
  #    puts "Association already exists!"
    end
  end
end

def add_new_drink(drink_name)
  # takes a drink name, and adds a new drink entry, intructions, any new ingredients, and related associations to the database.
  return nil if drink_name == "CANCEL"
  if Drink.all.find_by(name: drink_name) != nil
    puts "This drink is already in the database!".red
    return nil
  end
  drink_hash = get_drink_hash(drink_name)
  puts "Downloaded drink: ".magenta + drink_name.light_magenta
  ingredient_array = get_ingredients(drink_hash)
  puts "Downloaded ingredients: ".magenta + ingredient_array.to_s.light_magenta
  new_instructions = get_instructions(drink_hash)
  puts "Downloaded instructions.".magenta
  ingredient_add(ingredient_array)
  puts "Added ingredients to database!".magenta
  Drink.find_or_create_by(name: drink_name, instructions: new_instructions)
  puts "Added drink #{drink_name} to database!".magenta
  make_joiner_entries(Drink, Ingredient, get_drink_id_and_ingredient_ids(drink_name))
  box_this_text("Successfully added #{drink_name}", "light_cyan", "yes")
end

def add_custom_drink(custom_drink_hash)
  # takes a custom drink hash, and adds a new drink entry, intructions, any new ingredients, and related associations to the database.
  if custom_drink_hash == nil
    return nil
  end
  if Drink.all.find_by(name: custom_drink_hash[:name]) != nil
    puts "A duplicate drink name is already in the database!".red
    return nil
  end
  Drink.find_or_create_by(name: custom_drink_hash[:name], instructions: custom_drink_hash[:instructions])
  puts "Added drink #{custom_drink_hash[:name]} to database!".magenta
  make_joiner_entries(Drink, Ingredient, get_drink_id_and_ingredient_ids(custom_drink_hash[:name], custom_drink_hash[:ingredients]))
end

def bulk_joiner
  # This development method was used to automatically create associations between all of the initial 20 drinks in the database.
  cocktail_array = ["Martini","Manhattan","Old Fashioned","Mint Julep","Mojito","Margarita","Daiquiri","Tom Collins","Martinez","Brandy Cocktail","Brandy Daisy","Sidecar","Whiskey Sour","Sazerac","New Orleans Fizz","French 75","Negroni","Brandy Alexander","Bronx Cocktail"]

  cocktail_array.each do |cocktail|
    make_joiner_entries(Drink, Ingredient, get_drink_id_and_ingredient_ids(cocktail))
  end
end
