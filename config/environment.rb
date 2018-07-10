require 'bundler'
Bundler.require

require 'rest-client'
require 'json'
require 'pry'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
# require_all 'lib'
# require_all 'dev'
require_relative '../dev/api_communicator.rb'

binding.pry
