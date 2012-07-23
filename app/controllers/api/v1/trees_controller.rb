class Api::V1::TreesController < ApplicationController

  def show
    @seed = Seed.find(:id => params["id"])
    render :json => show_tree(@seed)
    #render :json => json_response
    #@seed.outgoing(:reseeds).outgoing(:helpers).depth(:all).include_start_node.raw.paths do |json, path| 
    # raise @seed.reseeds.count.inspect
    #unless @seed
    #render :json => {error: "The specified seed does not exist."}, :status => :not_found
    #end
  end

  def show_tree(parent)
    start = parent.id.to_i
    tree_hash = { start => { :children => {}, :payout_cents => parent.pledge.payout_cents, 
                             :amount_cents => parent.pledge.amount_cents,
                             :link => parent.link} }

    parent.outgoing(:reseeds).outgoing(:helpers).depth(:all).include_start_node.raw.paths.depth_first(:pre).each do |path|
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
end
