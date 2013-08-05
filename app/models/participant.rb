class Participant < Neo4j::Rails::Model
  property :created_at
  property :updated_at
  property :user_id

  has_one(:origin)

  def origin_link
    origin.link
  end

  def self.create_with_origin(origin, user_id)
    participant = Participant.create(:user_id => user_id)
    participant.origin = origin

    origin.outgoing(:helpers) << participant
    origin.save
    participant
  end
end
