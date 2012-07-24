if seed.pledge
	json.donation do |json|
		json.amount_cents seed.pledge.amount_cents
		json.payout_cents seed.pledge.payout_cents
	end
end
json.id seed.id
json.link seed.link
json.child_count seed.children_count
json.total_donated seed.total_donated
