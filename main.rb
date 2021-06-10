require 'sinatra'
require 'sinatra/reloader' if development?
require_relative 'db/helpers.rb'

# LOGIN/SIGNUP HELPERS

enable :sessions

def current_user
  if session[:user_id] == nil
    return {}
  end
  user_id = session[:user_id]
  run_sql("SELECT * FROM users WHERE user_id = $1;", [user_id])[0]
end

def logged_in?
  if session[:user_id] == nil
    return false
  else
    return true
  end
end

# MAIN REQUEST HANDLING

# HOMEPAGE

get '/' do
  redirect '/login' unless logged_in?

  erb :index
end

# PATCH CRUD

get '/patches' do
  redirect '/login' unless logged_in?

  sql_patches = "SELECT * FROM patches WHERE user_id = #{session[:user_id]};"
  patches = run_sql(sql_patches)
  themes = []

  patches.each do |patch|
    sql_themes = "SELECT * FROM themes WHERE (theme_id = $1 AND user_id = #{session[:user_id]});"
    themes.push(run_sql(sql_themes, [patch['theme_id']])[0])
  end
  erb :patch_list, locals: {patches: patches, themes: themes}
end

# create a patch - form

get '/patches/new' do
  redirect '/login' unless logged_in?

  sql_themes = "SELECT * FROM themes WHERE user_id = #{session[:user_id]};"
  themes = run_sql(sql_themes)
  erb :new_patch_form, locals: {themes: themes}
end

# submit created patch

post '/patches' do
  redirect '/login' unless logged_in?

  sql_patches = "INSERT INTO patches (patch_name, patch_desc, theme_id, user_id) VALUES ($1, $2, $3, #{session[:user_id]});"
  patch_info = [params['patch_name'], params['patch_desc'], params['theme_id']]
  run_sql(sql_patches, patch_info)

  redirect '/patches'
end

# view patchwork/ list of patches

get '/patches/:patch_id' do
  redirect '/login' unless logged_in?

  patch_id = [params['patch_id']]
  res = run_sql("SELECT * FROM patches WHERE (patch_id = $1 AND user_id = #{session[:user_id]});", patch_id)
  patch = res[0]

  songs = run_sql("SELECT * FROM songs WHERE patch_id = $1;", patch_id)

  theme = theme_from_id(patch['theme_id'])

  erb :show_patch, locals: {patch: patch, songs: songs, theme: theme}
end

# edit patch form

get '/patches/:patch_id/edit' do
  redirect '/login' unless logged_in?

  patch_id = [params['patch_id']]
  res = run_sql("SELECT * FROM patches WHERE (patch_id = $1 AND user_id = #{session[:user_id]});", patch_id)
  patch = res[0]

  songs = run_sql("SELECT * FROM songs WHERE patch_id = $1;", patch_id)
  themes = run_sql("SELECT * FROM themes WHERE user_id = #{session[:user_id]};")
  erb :edit_patch_form, locals: {patch: patch, songs: songs, themes: themes}
end

# update patch

put '/patches/:patch_id' do
  redirect '/login' unless logged_in?

  sql_patch = "UPDATE patches SET patch_name = $1, patch_desc = $2, theme_id = $3 WHERE (patch_id = $4 AND user_id = #{session[:user_id]});"
  patch_info = [params['patch_name'], params['patch_desc'], params['theme_id'], params['patch_id']]
  run_sql(sql_patch, patch_info)

  redirect "/patches/#{params['patch_id']}"
end

# delete a patch

delete '/patches/:patch_id' do
  redirect '/login' unless logged_in?

  patch_id = [params['patch_id']]
  sql = "DELETE FROM patches WHERE (patch_id = $1 AND user_id = #{session[:user_id]});"
  run_sql(sql, patch_id)
  redirect '/patches'
end

# SONG CRUD

# new song form

get '/patches/:patch_id/songs/new' do
  redirect '/login' unless logged_in?

  erb :new_song_form, locals: {patch_id: params['patch_id'], patch_name: patch_name(params['patch_id'])}
end

# submit new song

post '/patches/:patch_id/songs' do
  redirect '/login' unless logged_in?

  sql_songs = "INSERT INTO songs (song_name, song_desc, patch_id, artist, album, year) VALUES ($1,$2,$3,$4,$5,$6);"
  song_info = [params['song_name'], params['song_desc'], params['patch_id'], params['artist'], params['album'], params['year']]
  run_sql(sql_songs, song_info)

  redirect "/patches/#{params['patch_id']}"
end

# edit song form

get '/patches/:patch_id/songs/:song_id' do
  redirect '/login' unless logged_in?

  song = song_from_id(params['song_id'])
  erb :edit_song_form, locals: {song_id: params['song_id'], patch_id: params['patch_id'], song: song}
end

# submit edited song

put '/patches/:patch_id/songs/:song_id' do
  redirect '/login' unless logged_in?

  sql_song = "UPDATE songs SET song_name = $1, song_desc = $2, patch_id = $3, artist = $4, album = $5, year = $6 WHERE song_id = $7;"
  song_info = [params['song_name'], params['song_desc'], params['patch_id'], params['artist'], params['album'], params['year'], params['song_id']]
  run_sql(sql_song, song_info)
  redirect "/patches/#{params['patch_id']}"
end

# delete song

delete '/patches/:patch_id/songs/:song_id' do
  redirect '/login' unless logged_in?

  sql_song = "DELETE FROM songs WHERE song_id = $1;"
  run_sql(sql_song, [params['song_id']])
  redirect '/patches/:patch_id'
end

# THEME CRUD

# theme list

get '/themes' do
  redirect '/login' unless logged_in?

  sql_themes = "SELECT * FROM themes WHERE user_id = $1;"
  themes = run_sql(sql_themes, [session[:user_id]])
  erb :theme_list, locals: {themes: themes}
end

# make a new theme

get '/themes/new' do
  redirect '/login' unless logged_in?

  erb :new_theme_form
end

# theme details viewer

get '/themes/:id' do
  redirect '/login' unless logged_in?

  sql_theme = "SELECT * FROM themes WHERE theme_id = $1;"
  theme_id = [params['id']]
  theme = run_sql(sql_theme, theme_id)
  erb :show_theme, locals: {theme: theme, theme_id: theme_id}
end

# edit theme form

get '/themes/:id/edit' do
  redirect '/login' unless logged_in?

  erb :edit_theme_form, locals: {theme: theme_from_id(params['id'])}
end

# submit edited theme

put '/themes/:id/edit' do
  redirect '/login' unless logged_in?

  sql = "UPDATE themes SET theme_name = $1, main_img_url = $2, bg_img_url = $3 WHERE theme_id = $4;"
  theme_info = [params['theme_name'], params['main_img_url'], params['bg_img_url'], params['id']]
  run_sql(sql, theme_info)

  redirect '/themes'
end

# submit new theme

post '/themes' do
  redirect '/login' unless logged_in?

  sql = "INSERT INTO themes (theme_name, main_img_url, bg_img_url, user_id) VALUES ($1, $2, $3, $4);"
  theme_info = [params['theme_name'], params['main_img_url'], params['bg_img_url'], session[:user_id]]
  run_sql(sql, theme_info)

  redirect '/themes'
end

# LOGIN/SIGNUP - USER CRUD

get '/login' do
  erb :login
end

post '/session' do
  records = run_sql("SELECT * FROM users WHERE user_name = '#{params["user_name"]}';")
  if records.count > 0 && BCrypt::Password.new(records[0]['password_digest']) == params['password']
    logged_in_user = records[0]
    session[:user_id] = logged_in_user["user_id"]
    if no_themes?(session[:user_id])
      add_default_themes(session[:user_id])
    end
    redirect '/patches'
  else
    erb :login
  end
end

delete '/session' do
  session[:user_id] = nil
  redirect '/login'
end

get '/signup' do
  erb :new_user_form
end

post '/signup' do
  password_digest = BCrypt::Password.create(params['password'])
  sql_signup = "INSERT INTO users (user_name, password_digest) VALUES ($1, $2);"
  user_info = [params['user_name'], password_digest]
  run_sql(sql_signup, user_info)
  redirect '/login'
end










