require 'bundler'
Bundler.require

require 'rest-client'
require 'json'
require 'pry'
require 'colorize'
require 'tty-prompt'
require 'artii'
# require 'pry'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'
require_all 'dev'
# require_all 'db'
# require_relative '../dev/api_communicator.rb'
ActiveRecord::Base.logger = nil
# binding.pry
a = Artii::Base.new :font => 'o8'
