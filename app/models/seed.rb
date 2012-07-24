class Seed < Neo4j::Rails::Model
  property  :link
  property  :created_at
  property  :updated_at
  property  :user_id

  has_one(:pledge)
  has_n(:helpers).to(Participant)
  has_n(:reseeds).to(Seed)

  index :link

  def tree
    start = id.to_i
    tree_hash = { start => { :children => {}, :payout_cents => pledge.payout_cents, 
                             :amount_cents => pledge.amount_cents,
                             :link => link, :children_count => children_count, 
                             :total_donated => total_donated }}

    outgoing(:reseeds).outgoing(:helpers).depth(:all).include_start_node.raw.paths.depth_first(:pre).each do |path|
      path_nodes = path.nodes.to_a
      tree_walk = tree_hash[path_nodes.first.id]
     
      path_nodes[1..-1].each do |node|
        unless tree_walk[:children][node.id]
          tree_walk[:children].merge!({ node.id => { :children => {}}})
        end

        if path.end_node == node
          new_hash = {}
          if path.last_relationship
            rel_type = path.last_relationship.rel_type
            new_hash[:type] = rel_type
            new_hash[:id] = node.id

            if rel_type == :reseeds
              seed = Seed.find(node.id)
              new_hash[:payout_cents] = seed.pledge.payout_cents
              new_hash[:amount_cents] = seed.pledge.amount_cents
              new_hash[:link] = seed.link
            end
          end

          tree_walk[:children][node.id].merge!(new_hash)
        end

        tree_walk = tree_walk[:children][node.id]
      end
    end
    tree_hash
  end
   
  def children_count
    outgoing(:helpers).depth(:all).count
  end

  def total_donated
    children_count * pledge.payout_cents
  end

  def self.plant(user_id, amount_cents)
    unique_url = generate_link
    seed = Seed.create(:user_id => user_id, :link => unique_url)
    donation = create_donation(amount_cents)
    seed.pledge = donation
    seed.save
    seed
  end

  def self.reseed(user_id, link, amount_cents)
    child = plant(user_id, amount_cents)
    parent_seed = Seed.find(:link => link)
    parent_seed.outgoing(:reseeds) << child
    parent_seed.save
    parent_seed
  end

  # These likely belong elsewhere.
  def self.generate_link
    Digest::MD5.hexdigest("#{Time.now.usec} + #{rand(42)}")
  end

  def self.create_donation(amount_cents)
    donation = Donation.create(:amount_cents => amount_cents,
                               :payout_cents => 100)
  end

private
end
