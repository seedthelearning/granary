json.array!(@seeds) do |json, seed|
  json.partial! seed
end