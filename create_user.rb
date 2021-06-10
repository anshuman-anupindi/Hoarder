require 'bcrypt'
require_relative 'db/helpers.rb'
# user_name = "anshuman"
# password = "precious"
# password_digest = BCrypt::Password.create(password)
# sql = "INSERT INTO users (user_name, password_digest) VALUES ($1, $2);"
# run_sql(sql, [user_name, password_digest])

user_name2 = "dt"
password2 = "precious"
password_digest2 = BCrypt::Password.create(password2)
sql2 = "INSERT INTO users (user_name, password_digest) VALUES ($1, $2);"
run_sql(sql2, [user_name2, password_digest2])