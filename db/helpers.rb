require 'pg'
require 'pry'
require 'bcrypt'

def run_sql(sql, params = [])
    db = PG.connect(dbname: 'patchwork')
    res = db.exec_params(sql, params)
    db.close
    return res
end

def patch_name(patch_id)
    sql = "SELECT patch_name FROM patches WHERE patch_id = $1"
    patch_id = [patch_id]
    run_sql(sql, patch_id)[0]['patch_name']
end

def song_from_id(song_id)
    sql = "SELECT * FROM songs WHERE song_id = $1"
    song_id = [song_id]
    run_sql(sql, song_id)[0]
end

def theme_from_id(theme_id)
    sql = "SELECT * FROM themes WHERE theme_id = $1"
    theme_id = [theme_id]
    run_sql(sql, theme_id)[0]
end