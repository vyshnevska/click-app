# set utf-8 for outgoing
before do
  headers "Content-Type" => "text/html; charset=utf-8"
end

get '/' do
  @title = "Welcome Click App!"
  erb :welcome
end

get '/ad' do
  id = repository(:default).adapter.query(
    'SELECT id FROM ads ORDER BY random() LIMIT 1;'
    )
  @ad = Ad.get(id)
  erb :ad#, layout: false
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
  ad = Ad.get(params[:id])
  unless ad.nil?
    path = File.join(Dir.pwd, "/public/ads", ad.filename)
    File.delete(path) if File.exists?(path)
    ad.destroy
  end
  redirect('/list')
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
  ad = Ad.get(params[:id])
  ad.clicks.create(ip_address: env["REMOTE_ADDR"])
  redirect(ad.url)
end

