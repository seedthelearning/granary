json.id @seed.id
json.link @seed.link
json.type "seed"

json.children @seed.reseeds do |json, reseed|
  json.id reseed.id
  json.link reseed.link
  json.type "seed"
end