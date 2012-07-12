class Seed < Neo4j::Rails::Model
  property  :link
  property  :created_at
  property  :updated_at

  has_one(:pledge)
  has_n(:helpers)
end
