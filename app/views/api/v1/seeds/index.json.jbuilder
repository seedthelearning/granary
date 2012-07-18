json.array!(@seeds) do |json, seed|
  json.partial! "api/v1/seeds/seed", :seed => seed
end