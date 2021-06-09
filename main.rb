require 'sinatra'
require 'sinatra/reloader'
require_relative 'db/helpers.rb'

# enable :sessions

# def current_user
#   if session[:user_id] == nil
#     return {}
#   end
#   user_id = session[:user_id]
#   run_sql("SELECT * FROM users WHERE id = $1;", [user_id])
# end

# def logged_in?
#   if session[:user_id] == nil
#     return false
#   else
#     return true
#   end
# end

get '/' do
  erb :index
end

# PATCH CRUD

get '/patches' do
  sql_patches = "SELECT * FROM patches;" # WHERE user_id = #{session[:user_id]}
  patches = run_sql(sql_patches)
  themes = []

  patches.each do |patch|
    sql_themes = "SELECT * FROM themes WHERE theme_id = $1;"
    themes.push(run_sql(sql_themes, [patch['theme_id']])[0])
    # sql_themes = "SELECT * FROM themes WHERE (theme_id = $1 AND user_id = $2);"
    # themes.push(run_sql(sql_themes, [patch['theme_id'], session[:user_id]])[0])
  end
  erb :patch_list, locals: {patches: patches, themes: themes}
end

# create a patch - form

get '/patches/new' do
  sql_themes = "SELECT * FROM themes;"
  themes = run_sql(sql_themes)
  erb :new_patch_form, locals: {themes: themes}
end

# submit created patch

post '/patches' do
  sql_patches = "INSERT INTO patches (patch_name, patch_desc, theme_id) VALUES ($1, $2, $3);"
  patch_info = [params['patch_name'], params['patch_desc'], params['theme_id']]
  run_sql(sql_patches, patch_info)

  redirect '/patches'
end

# view patchwork/ list of patches

get '/patches/:patch_id' do
  patch_id = [params['patch_id']]
  res = run_sql("SELECT * FROM patches WHERE patch_id = $1;", patch_id)
  patch = res[0]

  songs = run_sql("SELECT * FROM songs WHERE patch_id = $1;", patch_id)

  erb :show_patch, locals: {patch: patch, songs: songs}
end

# edit patch form

get '/patches/:patch_id/edit' do
  patch_id = [params['patch_id']]
  res = run_sql("SELECT * FROM patches WHERE patch_id = $1;", patch_id)
  patch = res[0]

  songs = run_sql("SELECT * FROM songs WHERE patch_id = $1;", patch_id)
  themes = run_sql("SELECT * FROM themes;")
  erb :edit_patch_form, locals: {patch: patch, songs: songs, themes: themes}
end

# update patch

put '/patches/:patch_id' do
  sql_patch = "UPDATE patches SET patch_name = $1, patch_desc = $2, theme_id = $3 WHERE patch_id = $4;"
  patch_info = [params['patch_name'], params['patch_desc'], params['theme_id'], params['patch_id']]
  run_sql(sql_patch, patch_info)

  redirect "/patches/#{params['patch_id']}"
end

# delete a patch

delete '/patches/:patch_id' do
  patch_id = [params['patch_id']]
  sql = "DELETE FROM patches WHERE patch_id = $1"
  run_sql(sql, patch_id)
  redirect '/patches'
end

# SONG CRUD

# new song form

get '/patches/:patch_id/songs/new' do
  erb :new_song_form, locals: {patch_id: params['patch_id'], patch_name: patch_name(params['patch_id'])}
end

# submit new song

post '/patches/:patch_id/songs' do
  sql_songs = "INSERT INTO songs (song_name, song_desc, patch_id, artist, album, year) VALUES ($1,$2,$3,$4,$5,$6)"
  song_info = [params['song_name'], params['song_desc'], params['patch_id'], params['artist'], params['album'], params['year']]
  run_sql(sql_songs, song_info)

  redirect "/patches/#{params['patch_id']}"
end

# edit song form

get '/patches/:patch_id/songs/:song_id' do
  song = song_from_id(params['song_id'])
  erb :edit_song_form, locals: {song_id: params['song_id'], patch_id: params['patch_id'], song: song}
end

# submit edited song

put '/patches/:patch_id/songs/:song_id' do
  sql_song = "UPDATE songs SET song_name = $1, song_desc = $2, patch_id = $3, artist = $4, album = $5, year = $6 WHERE song_id = $7"
  song_info = [params['song_name'], params['song_desc'], params['patch_id'], params['artist'], params['album'], params['year'], params['song_id']]
  run_sql(sql_song, song_info)
  redirect "/patches/#{params['patch_id']}"
end

# delete song

delete '/patches/:patch_id/songs/:song_id' do
  sql_song = "DELETE FROM songs WHERE song_id = $1"
  run_sql(sql_song, [params['song_id']])
  redirect '/patches/:patch_id'
end

# THEME CRUD

# theme list

get '/themes' do
  sql_themes = "SELECT * FROM themes;"
  themes = run_sql(sql_themes)
  erb :theme_list, locals: {themes: themes}
end

# theme details viewer

get '/themes/:id' do
  sql_theme = "SELECT * FROM themes WHERE theme_id = $1;"
  theme_id = [params['id']]
  theme = run_sql(sql_theme, theme_id)
  erb :show_theme, locals: {theme: theme, theme_id: theme_id}
end

# edit theme form

get '/themes/:id/edit' do
end

put '/themes/:id/edit' do
end

get '/themes/new' do
end

post '/themes' do
end

# login page

get '/login' do

end

post '/session' do

end

delete '/session' do

end

get '/signup' do
  erb :new_user_form
end

post '/signup' do

end










