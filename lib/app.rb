require "sinatra"
require "sinatra/reloader" if development?
require "sqlite3"

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

# Then:
# 1. Create an artist page with all the albums. Display genres as well
# 2. Create an album pages with all the tracks
# 3. Create a track page with all the track info
