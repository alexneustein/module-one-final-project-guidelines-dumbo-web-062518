require 'rest-client'
require 'json'
require 'pry'

# These methods are used to scrape the drink instructions and ingredients from the cocktail DB site.

cocktail_array = ["Martini","Manhattan","Old Fashioned","Mint Julep","Mojito","Margarita","Daiquiri","Tom Collins","Martinez","Brandy Cocktail","Brandy Daisy","Sidecar","Whiskey Sour","Sazerac","New Orleans Fizz","French 75","Negroni","Brandy Alexander","Bronx Cocktail"]

def get_drink_hash(drink)
  #gets the drink hash
  all_drinks = RestClient.get('https://www.thecocktaildb.com/api/json/v1/1/search.php?s=' + drink.to_s)
  wrapper_hash = JSON.parse(all_drinks)
  wrapper_hash["drinks"].kind_of?(Array) ? drink_hash = wrapper_hash["drinks"][0] : drink_hash = wrapper_hash["drinks"]
end

def get_ingredients(drink_hash)
  # Refactor into an iterator using a counter & string interpolation
  return [] if drink_hash == nil
  ingredient_array = drink_hash.fetch_values("strIngredient1",
 "strIngredient2",
 "strIngredient3",
 "strIngredient4",
 "strIngredient5",
 "strIngredient6",
 "strIngredient7",
 "strIngredient8",
 "strIngredient9",
 "strIngredient10",
 "strIngredient11",
 "strIngredient12",
 "strIngredient13",
 "strIngredient14",
 "strIngredient15")
 ingredient_array.delete("")
 return ingredient_array
end

def get_instructions(drink_hash)
  instruction_string = drink_hash["strInstructions"]
end

def build_master_list(drink_names_array)
  master_ingredient_list = []
  drink_names_array.each do |drink_name|
    master_ingredient_list << get_ingredients(get_drink_hash(drink_name)).compact
    master_ingredient_list = master_ingredient_list.flatten
    master_ingredient_list = master_ingredient_list.uniq
  end
  master_ingredient_list
end
