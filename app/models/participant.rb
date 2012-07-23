class Participant < Neo4j::Rails::Model
  property :created_at
  property :updated_at
  property :user_id

  has_one(:origin)
  
  def origin_link
  	origin.link
  end

  def self.create_with_origin(origin)
    participant = Participant.create
    participant = origin.helpers.create
    participant.origin = origin

    origin.outgoing(:helpers) << participant
    origin.save
    participant
  end
end
