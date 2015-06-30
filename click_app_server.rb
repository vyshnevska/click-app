require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-timestamps'
require 'dm-migrations'
require './lib/authorization'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/click_app.db")

require './models/ad'
require './models/click'
require './routes/ads'

configure :development do
  # Create or upgrade all tables at once
  DataMapper.auto_upgrade!
end

helpers do
  include Sinatra::Authorization
end


