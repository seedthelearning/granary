class Participant < Neo4j::Rails::Model
  property :created_at
  property :updated_at

  has_one(:origin)
  
  def origin_link
  	origin.link
  end

  def self.create_with_origin(origin)
    participant = origin.helpers.create
    participant.origin = origin
    participant
  end
end