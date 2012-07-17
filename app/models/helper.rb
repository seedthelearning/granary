class Helper < Neo4j::Rails::Model
  # JQTODO: What other properties? :link?
  property :created_at
  property :updated_at

  has_one(:helping)
  # JQTODO: Is this the right word?
end