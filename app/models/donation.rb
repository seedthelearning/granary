class Donation < Neo4j::Rails::Model
  property :amount_cents
  property :payout_cents
  property :created_at
  property :updated_at

  has_one(:pledge)
end
