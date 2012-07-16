class Seed < Neo4j::Rails::Model
	property  :link
	property  :created_at
	property  :updated_at

	has_one(:pledge)
	has_n(:helpers)

	def self.plant(link, amount_cents)
		seed = Seed.create(:link => link)

		if amount_cents
			donation = Donation.create(:amount_cents => amount_cents,
				:payout_cents => 100)
			seed.outgoing(:pledge) << donation
		end
		seed
	end
end
