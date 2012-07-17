class Seed < Neo4j::Rails::Model
	property  :link
	property  :created_at
	property  :updated_at

	has_one(:pledge)
	has_n(:helpers).to(Participant)
	has_n(:reseeds).to(Seed)

	index :link

	def self.plant(amount_cents)
		unique_url = generate_link
		seed = Seed.create(:link => unique_url)
		donation = create_donation(amount_cents)
		seed.pledge = donation
		seed
	end

	def self.reseed(link, amount_cents)
		child = plant(amount_cents)
		parent_seed = Seed.find(:link => link)
		parent_seed.reseeds << child
	end

	# These likely belong elsewhere.
	def self.generate_link
		Digest::MD5.hexdigest(Time.now.to_s)
		# JQTODO: Add another criteria to save against race conditions.
	end

	def self.create_donation(amount_cents)
		donation = Donation.create(:amount_cents => amount_cents,
				:payout_cents => 100)
	end
end
