json.array!(@locations) do |location|
  json.extract! location, :id, :latitude, :longitude, :full_street_address, :movie_id
  json.movie_title location.movie.title
  json.url location_url(location, format: :json)
end
