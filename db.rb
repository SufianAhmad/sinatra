env = ENV["RACK_ENV"] || "development"
url = "sqlite://#{Dir.pwd}/db/#{env}.sqlite3"
DataMapper.setup :default, url

class Image
  include DataMapper::Resource

  property :id, Serial
  property :url, String, length: 0..2500
  property :title, String, length: 0..250
  property :desc, Text
end

DataMapper.finalize
DataMapper.auto_upgrade!
