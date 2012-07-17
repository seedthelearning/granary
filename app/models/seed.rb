class Seed < Neo4j::Rails::Model
	property  :link
	property  :created_at
	property  :updated_at

	has_one(:pledge)
	# has_n(:helpers) JQTODO: We may not need this connection
	has_n(:reseeds)

	index :link

  # call this plant
	def self.create_seed(amount_cents)
		unique_url = generate_link
		seed = Seed.create(:link => unique_url)
		donation = create_donation(amount_cents)
		seed.pledge = donation
		seed
	end

	# call this reseed
	def self.plant(link, amount_cents)
		child = create_seed(amount_cents)
		parent_seed = Seed.find(:link => link)
		parent_seed.reseeds << child
	end

private
	def self.generate_link
		Digest::MD5.hexdigest(Time.now.to_s)
	end

	def self.create_donation(amount_cents)
		donation = Donation.create(:amount_cents => amount_cents,
				:payout_cents => 100)
	end
end
