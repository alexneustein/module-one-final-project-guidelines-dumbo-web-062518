require_relative '../config/environment'



puts "HELLO WORLD"



martini = Drink.create(name: "Martini", instructions: "Blah blah")
gin = Ingredient.create(name: "Gin", category: "Spirit", keyword: "Gin")
whiskey = Ingredient.create(name: "Whisky", category: "Spirit", keyword: "Whisky")
dryvermouth = Ingredient.create(name: "Dry Vermouth", category: "liqueur", keyword: "Vermouth")
