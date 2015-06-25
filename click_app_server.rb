require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-timestamps'
require 'dm-migrations'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/click_app.db")

class Ad
  include DataMapper::Resource

  property :id,             Serial
  property :title,          String
  property :content,        Text
  property :width,          Integer
  property :height,         Integer
  property :filename,       String
  property :url,            String
  property :is_active,      Boolean
  property :created_at,     DateTime
  property :updated_at,     DateTime
  property :size,           Integer
  property :content_type,   String
end

# Create or upgrade all tables at once
DataMapper.auto_upgrade!
