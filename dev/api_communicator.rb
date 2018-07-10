require 'rest-client'
require 'json'
require 'pry'



def get_drink(drink)
  #gets the drink hash
  all_drinks = RestClient.get('https://www.thecocktaildb.com/api/json/v1/1/search.php?s=' + drink.to_s)
  drink_hash = JSON.parse(all_drinks)
  selected_drink = drink_hash["drinks"][0]
  binding.pry
end

get_drink("margarita")

# def get_character_movies_from_api(character)
#   found_character_hash = get_character_hash_from_api(character)
#
#   movies_array = []
#
#   while found_character_hash == nil
#     puts "Character Not Found. Please put a valid character."
#     character = get_character_from_user
#     found_character_hash = get_character_hash_from_api(character)
#   end
#
#   the_URLs_array = found_character_hash["films"]
#   the_URLs_array.each do |url|
#   movies_array << JSON.parse(RestClient.get(url))
#
# end
# return movies_array
#   # iterate over the character hash to find the collection of `films` for the given
#   #   `character`
#   # collect those film API urls, make a web request to each URL to get the info
#   #  for that film
#   # return value of this method should be collection of info about each film.
#   #  i.e. an array of hashes in which each hash reps a given film
#   # this collection will be the argument given to `parse_character_movies`
#   #  and that method will do some nice presentation stuff: puts out a list
#   #  of movies by title. play around with puts out other info about a given film.
# end
#
#
# def parse_character_movies(films_hash)
#   relevant_stuff = ["title", "episode id", "producer", "director", "release date"]
#
#   films_hash.map do |movie_hash|
#     movie_hash.map do |key, detail|
#       relevant_stuff.each do |category|
#         if key == category
#           print key.sub("_", " ")
#           print ": "
#           puts detail
#           puts "" if key == "producer"
#         end
#       end
#     end
#   end
# end
#
# # Luke_movie_hash = get_character_movies_from_api("Luke Skywalker")
# # parse_character_movies(Luke_movie_hash)
#
#
# def show_character_movies(character)
#   films_hash = get_character_movies_from_api(character)
#   parse_character_movies(films_hash)
# end

## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
