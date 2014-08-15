require 'sinatra'
require 'dalli'
require 'memcachier'

set :cache, Dalli::Client.new

if ENV['MEMCACHEDCLOUD_PASSWORD'] && ENV['MEMCACHEDCLOUD_SERVERS'] && ENV['MEMCACHEDCLOUD_USERNAME']
  set :cache, Dalli::Client.new(ENV["MEMCACHEDCLOUD_SERVERS"],
    {:username => ENV["MEMCACHEDCLOUD_USERNAME"], :password => ENV["MEMCACHEDCLOUD_PASSWORD"]}
  )
else
  set :cache, Dalli::Client.new
end

get '/:id' do
  result = settings.cache.get(params[:id])

  if result
    result
  else
    status 404
  end
end

post '/:id' do
  request.body.rewind
  payload =  request.body.read
  settings.cache.set(params[:id], payload, 60 * 60 * 60)
  payload
end
