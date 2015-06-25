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

# set utf-8 for outgoing
before do
  headers "Content-Type" => "text/html; charset=utf-8"
end

get '/' do
  @title = "Welcome Click App!"
  erb :welcome
end

get '/ad' do
end

get '/list' do
  @title = 'List of Ads'
  @ads = Ad.all(order: [:created_at.desc])
  erb :list
end

get '/new' do
  @title = "New Ad"
  erb :new
end

post '/create' do
  @ad = Ad.new(params[:ad])
  @ad.content_type = params[:image][:type]
  @ad.size = File.size(params[:image][:tempfile])
  if @ad.save
    path = File.join(Dir.pwd, "/public/ads", @ad.filename)
    File.open(path, 'wb') do |f|
      f.write(params[:image][:tempfile].read)
    end
    redirect "/show/#{@ad.id}"
  else
    redirect('/list')
  end
end

get '/delete/:id' do
end

get '/show/:id' do
  @ad = Ad.get(params[:id])
  if @ad
    erb :show
  else
    redirect('/list')
  end
end

get '/click/:id' do
end

