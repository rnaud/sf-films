# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'open-uri'

json_object = JSON.parse(open("https://data.sfgov.org/resource/yitu-d5am.json").read)

directors = {}
producers = {}
movies = {}

json_object.each do |hash|
  puts hash
  
  if !producers[hash["production_company"]]
    producers[hash["production_company"]] = Producer.create(:name => hash["production_company"])
  end
  if !directors[hash["director"]]
    directors[hash["director"]] = Director.create(:name => hash["director"])
  end

  if !movies[hash["title"]+hash["release_year"]] # I use the double key of title and year to make sure 
    #that I don't have two movies with the same name
    uri = URI.escape("http://www.omdbapi.com/?t=#{hash['title']}&y=#{hash['release_year']}")
    movie_data = JSON.parse(open(uri).read)
    puts movie_data

    m = Movie.new
    m.title = hash["title"]
    m.year = hash["release_year"]
    m.fun_fact = hash["fun_fact"]
    m.producer = producers[hash["production_company"]]
    m.director = directors[hash["director"]]
    m.imdb_id = movie_data["imdbID"]
    m.imdb_rating = movie_data["imdbRating"]
    m.poster_url = movie_data["Poster"]
    m.plot = movie_data["Plot"]
    m.actors = movie_data["Actors"].split(", ") if movie_data["Actors"]
    m.save

    movies[hash["title"]+hash["release_year"]] = m

  end

  if hash["locations"]
    loc = Location.new
    loc.full_street_address = hash["locations"] + " San Francisco" # I add San Francisco to the 
    # full address so that the address can be geocoded
    loc.movie = movies[hash["title"]+hash["release_year"]]
    loc.save
  end


  
end