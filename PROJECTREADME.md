Cocktail Recipe Application!

By: https://github.com/alexneustein & https://github.com/runandrerun

Overview:
Our application is there to simplify and add joy to the experience of being a home bartender.

- Browse from a great selection of 20 classic cocktails,
- Search by ingredients or by drink name
- Save your favorites,
- Keep track of your pantry to see what ingredients you have, what recipes you can make, or what you should stock up on.
- The app can tell you all of the drinks you can make with the ingredients you have.
- Search the web for hundreds of additional cocktails by name and add them to your guide.
- You can even add and save custom cocktails.
- Multiple users can save their own favorite recipes and bar pantries.

Setup:

1. Run 'bundle install' prior to starting up the application.

2. If starting fresh, run the following commands to seed your existing database: 'rake db:migrate', and 'rake db:seed'.

3. If the relations between Drinks & Ingredients does not work, enter 'rake console', and run 'bulk_joiner' - This will create relations between the drinks and ingredients tables if it doesn't exist after seeding the database.

4. Run the application with 'ruby bin/run.rb'

5. You should be prompted with the landing page to our CLI application.  

How to Use:

1. All actions are done via menus. You can use the arrow keys on your keyboard, and hit enter to select a choice.

2. For multi-selection areas, such as selecting multiple drinks or ingredients to add to your favorites/pantry, use the space bar to select and then hit enter when finished.

3. the 'Find', and 'Create' options require manual input via text on your keyboard.
