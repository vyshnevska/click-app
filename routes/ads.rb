# set utf-8 for outgoing
before do
  headers "Content-Type" => "text/html; charset=utf-8"
end

get '/' do
  @title = "Welcome Click App!"
  @page_header = "Welcome to the Click Tracking App!"
  haml :welcome
end

get '/ad' do
  @page_header = "A single ad"
  id = repository(:default).adapter.query(
    'SELECT id FROM ads ORDER BY random() LIMIT 1;'
    )
  @ad = Ad.get(id)
  haml :ad#, layout: false
end

get '/list' do
  require_admin
  @title = 'List of Ads'
  @ads = Ad.all(order: [:created_at.desc])
  haml :list
end

get '/new' do
  require_admin
  @page_header = "A new ad"
  @title = "New Ad"
  haml :new
end

post '/create' do
  require_admin
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
  require_admin
  ad = Ad.get(params[:id])
  unless ad.nil?
    path = File.join(Dir.pwd, "/public/ads", ad.filename)
    File.delete(path) if File.exists?(path)
    ad.destroy
  end
  redirect('/list')
end

get '/show/:id' do
  require_admin
  @page_header = "An ad"
  @ad = Ad.get(params[:id])
  if @ad
    haml :show
  else
    redirect('/list')
  end
end

get '/click/:id' do
  ad = Ad.get(params[:id])
  ad.clicks.create(ip_address: env["REMOTE_ADDR"])
  redirect(ad.url)
end

