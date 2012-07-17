json.donation do |json|
	json.amount_cents @seed.pledge.amount_cents
	json.payout_cents @seed.pledge.payout_cents
end
json.id @seed.id
json.link @seed.link
json.status :ok