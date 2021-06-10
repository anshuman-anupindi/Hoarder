require 'pg'
require 'pry'
require 'bcrypt'

def run_sql(sql, params = [])
    db = PG.connect(ENV['DATABASE_URL'] || {dbname: 'patchwork'})
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

def add_default_themes(user_id)
    sql = "INSERT INTO themes (theme_name, main_img_url, bg_img_url, user_id) VALUES ('Winter', 'https://us.123rf.com/450wm/sanchesnet1/sanchesnet11710/sanchesnet1171000020/88178154-winter-landscape-on-snowy-background-christmas-vector-illustration-.jpg?ver=6', 'https://i.pinimg.com/originals/4b/5c/3d/4b5c3db34db5fca887e159c6da28b2e6.jpg', #{user_id});"
    run_sql(sql)
    sql = "INSERT INTO themes (theme_name, main_img_url, bg_img_url, user_id) VALUES ('Summer', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7rxuMm7dkX_F3cG2yGLClSX1EE_mtAsobKw&usqp=CAU', 'https://www.teahub.io/photos/full/1-14023_summer-wallpaper-for-pc-summer-desktop-backgrounds.jpg', #{user_id});"
    run_sql(sql)
    sql = "INSERT INTO themes (theme_name, main_img_url, bg_img_url, user_id) VALUES ('Spring', 'https://lh3.googleusercontent.com/proxy/Bk35bDi5kXQXA-t-T-EChThz3cEtD-yMr40r4hEYExK_CQ4bbl7v1PC64_Ith6_eB51ApgTJZvDLnyN1T2MHwAmSnRC5UScCXHhupsYo0QGr6z5edC1_aCNygVRioXyblKmMkU-LVjj8Us6Me537', 'https://wallpaperaccess.com/full/490164.jpg', #{user_id});"
    run_sql(sql)
    sql = "INSERT INTO themes (theme_name, main_img_url, bg_img_url, user_id) VALUES ('Autumn', 'https://image.freepik.com/free-vector/autumn-pattern-background_3042-105.jpg', 'https://i.pinimg.com/originals/8b/a4/8a/8ba48af164ec7be8db9725e8e15484f2.jpg', #{user_id});"
    run_sql(sql)
    sql = "INSERT INTO themes (theme_name, main_img_url, bg_img_url, user_id) VALUES ('Vintage', 'mainimg', 'https://cdn.shopify.com/s/files/1/0285/1316/products/w0459_1s_Floral-Pattern-Wallpaper-for-Walls-Muted-Floral_Repeating-Pattern-Sample-1_10a71b1c-2c73-42e6-8343-a7a8469ec8f3.jpg?v=1604087784', #{user_id});"
    run_sql(sql)
    sql = "INSERT INTO themes (theme_name, main_img_url, bg_img_url, user_id) VALUES ('Cyberpunk', 'https://steamuserimages-a.akamaihd.net/ugc/946216664833233000/162955223A63FCC8F57B0922861CCA38C89AE413/?imw=512&&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false', 'https://i.imgur.com/7I8OmXT.jpg', #{user_id});"
    run_sql(sql)
    sql = "INSERT INTO themes (theme_name, main_img_url, bg_img_url, user_id) VALUES ('Steampunk', 'https://cdn.shopify.com/s/files/1/0539/4831/7877/products/steampunk-wolf-2_700x700.jpg?v=1614776928', 'https://wallpaperaccess.com/full/251905.jpg', #{user_id});"
    run_sql(sql)
    sql = "INSERT INTO themes (theme_name, main_img_url, bg_img_url, user_id) VALUES ('Nostalgia', 'https://i.ytimg.com/vi/WTaVL6k10wQ/hqdefault.jpg', 'https://i.ytimg.com/vi/rv8bb0ZhQvs/maxresdefault.jpg', #{user_id});"
    run_sql(sql)
end

def no_themes?(user_id)
    sql = "SELECT * FROM themes WHERE user_id = #{user_id};"
    user_themes = run_sql(sql)
    if user_themes.count == 0
        return true
    else
        return false
    end
end