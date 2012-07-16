class Seed < Neo4j::Rails::Model
	property  :link
	property  :created_at
	property  :updated_at

	has_one(:pledge)
	has_n(:helpers)

	def plant(amount_cents)
		# if params[:body][:amount_cents]
		# 	@seed = Seed.create(:link => params[:body][:link])
		# 	@donation = Donation.create(:amount_cents => params[:body][:amount_cents],
		# 		:payout_cents => 100)
		# 	@seed.outgoing(:pledge) << @donation
		# 	@donation.incoming(:pledge) << @seed
		# else
		# 	@seed = Seed.create(:link => params[:body][:link])    end
		# end
	end
end
