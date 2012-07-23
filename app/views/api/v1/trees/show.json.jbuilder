json.id @seed.id
json.link @seed.link
json.type "seed"

json.children @seed.outgoing(:reseeds).outgoing(:helpers).depth(:all).include_start_node.raw.paths do |json, path| 
 json.path path.nodes do |json, node|
   node.id
 end
end

 #json.children @seed.reseeds do |json, reseed|
   #json.id reseed.id
   #json.link reseed.link
   #json.type "seed"
 #end
