require "sinatra"
require "sinatra/reloader" if development?
require "sqlite3"
require 'json'
require 'open-uri'

DB = SQLite3::Database.new(File.join(File.dirname(__FILE__), 'db/jukebox.sqlite'))

get "/" do
  # TODO: Gather all artists to be displayed on home page
  @artists = DB.execute('SELECT name, id FROM artists').sort
  erb :home # Will render views/home.erb file (embedded in layout.erb)
end

get "/artist/:id" do
  DB.results_as_hash = false

  @albums = DB.execute('SELECT albums.title, albums.id FROM albums
                        JOIN artists ON artists.id = albums.artist_id
                        WHERE artist_id = ?', params[:id].to_i).sort
  @artist_name = DB.execute('SELECT name FROM artists
                             WHERE id = ?', params[:id].to_i).flatten[0]
  erb :artist
end

get "/album/:id" do
  DB.results_as_hash = false

  @tracks = DB.execute('SELECT tracks.name, tracks.id FROM tracks
                        JOIN albums ON albums.id = tracks.album_id
                        WHERE album_id = ?', params[:id].to_i).sort

  @album_name = DB.execute('SELECT title FROM albums
                            WHERE id = ?', params[:id].to_i).flatten[0]
  erb :album
end

get "/track/:id" do
  DB.results_as_hash = false

  @track = DB.execute('SELECT * FROM tracks
                       WHERE id = ?', params[:id].to_i).flatten
  erb :track
end
# Then:
# 1. Create an artist page with all the albums. Display genres as well
# 2. Create an album pages with all the tracks
# 3. Create a track page with all the track info
