class Node < Neo4j::Rails::Model
  property :username, default: "Foo"
  property :amount_cents

  index :username
  has_n(:pledges)
end
