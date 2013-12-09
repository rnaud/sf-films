json.extract! @location, :id, :latitude, :longitude, :full_street_address, :movie_id, :created_at, :updated_at
json.movie do
  json.extract! @location.movie, :id, :title, :year, :fun_fact, :producer_id, :director_id, :plot, :imdb_id, :imdb_rating, :poster_url, :actors
end
