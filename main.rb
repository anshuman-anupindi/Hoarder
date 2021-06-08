require 'sinatra'
require 'sinatra/reloader'
require_relative 'db/helpers.rb'

enable :sessions

# home page

get '/' do
  erb :index
end

# create a patchwork

get '/patches/new' do
end

post '/patches' do
end

# view patchwork/ list of patches

get '/patches/:id' do
end

# edit a patch

get '/patches/:id/edit' do
end

put '/patches/:id' do
end

# delete a patch

delete '/patches/:id' do
end











