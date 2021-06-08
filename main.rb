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

# home page - sign up, log in

get '/' do
  erb :index
end

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
  erb :new_patch_form
end

# submit created patch

post '/patches' do
  sql_themes = "INSERT INTO themes (theme_name, bg_img_url, main_img_url) VALUES ($1, $2, $3)"
  theme_info = [params['theme_name'], params['bg_img_url'], params['main_img_url']]

  sql_patches = "INSERT INTO patches (patch_name, patch_desc, theme_id) VALUES ($1, $2, $3)"
  patch_info = [params['patch_name'], params['patch_desc'], params['theme_id']]

  run_sql(sql_themes, theme_info)
  run_sql(sql_patch, patch_info)

  redirect '/patches'
end

# view patchwork/ list of patches

get '/patches/:id' do
  patch_id = [params['patch_id']]
  res = run_sql("SELECT * FROM patches WHERE patch_id = $1;", patch_id)
  patch = res[0]

  songs = run_sql("SELECT * FROM songs WHERE patch_id = $1;", patch_id)

  erb :show_patch, locals: {patch: patch, songs: songs}
end

# edit patch form

get '/patches/:id/edit' do
  patch_id = [params['patch_id']]
  res = run_sql("SELECT * FROM patches WHERE patch_id = $1;", patch_id)
  patch = res[0]
  erb :edit_patch_form, locals: {patch: patch}
end

# update patch

put '/patches/:id' do
  sql = "UPDATE patches SET patch_name = $1, patch_desc = $2, theme_id = $3;"
  patch_info = [params['patch_name'], params['patch_desc'], params['theme_id']]
  run_sql(sql, patch_info)
  redirect '/patches'
end

# delete a patch

delete '/patches/:id' do
  patch_id = [params['id']]
  sql = "DELETE FROM patches WHERE patch_id = $1"
  run_sql(sql, patch_id)
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










