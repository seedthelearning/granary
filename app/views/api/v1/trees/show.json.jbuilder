json.id @seed.id
json.link @seed.link
json.type "seed"
if @seed.reseeds.count == 0
  json.children []
end