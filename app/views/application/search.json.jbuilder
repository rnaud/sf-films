json.array! @results do |result|
  json.id result.id
  json.value result.name
  json.tokens [result.name]
  json.type result.class.name
  json.url locations_url("#{result.class.name.downcase}_id" => result.id)
end