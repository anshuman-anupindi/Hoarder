CREATE DATABASE patchwork;

CREATE TABLE songs (song_id SERIAL PRIMARY KEY, song_name TEXT, song_desc TEXT, patch_id INT, artist TEXT, album TEXT, year INT);
CREATE TABLE patches (patch_id SERIAL PRIMARY KEY, patch_name TEXT, theme_id INT, patch_desc TEXT, user_id INT);
CREATE TABLE themes (theme_id SERIAL PRIMARY KEY, theme_name TEXT, bg_img_url TEXT, main_img_url TEXT);
CREATE TABLE users (user_id SERIAL PRIMARY KEY, user_name text, password_digest TEXT);