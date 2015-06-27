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

  has n, :clicks
end
