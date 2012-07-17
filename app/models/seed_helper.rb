class Participant < Neo4j::Rails::Model
  property :created_at
  property :updated_at

  has_one(:helper)
end