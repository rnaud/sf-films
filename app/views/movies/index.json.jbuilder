json.array!(@movies) do |movie|
  json.extract! movie, :id, :title, :year, :fun_fact, :producer_id, :director_id
  json.url movie_url(movie, format: :json)
end
