require 'sinatra'
require 'dalli'
require 'memcachier'

set :cache, Dalli::Client.new

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
