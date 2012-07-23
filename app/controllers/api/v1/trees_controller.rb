class Api::V1::TreesController < ApplicationController

  def show
    @seed = Seed.find(params["id"]) 
    puts @seed.inspect 
    tree = Hash.new

    puts show_tree(@seed)
    @seed.outgoing(:reseeds).outgoing(:helpers).depth(:all).include_start_node.raw.paths.depth_first(:pre) do |path|

    end

    render :json => tree
    #render :json => json_response
    #@seed.outgoing(:reseeds).outgoing(:helpers).depth(:all).include_start_node.raw.paths do |json, path| 
    # raise @seed.reseeds.count.inspect
    #unless @seed
    #render :json => {error: "The specified seed does not exist."}, :status => :not_found
    #end
  end

  def self.show_tree(parent)
    node_lookup = { parent.id.to_i => STL::Path.new }
    start = parent.id.to_i

    tree_hash = { start => {:children => {}} }
    parent.outgoing(:reseeds).outgoing(:helpers).depth(:all).include_start_node.raw.paths.depth_first(:pre).each do |path|
      path_nodes = path.nodes.to_a
      tree_walk = tree_hash[path_nodes.first.id]
     
      path_nodes[1..-1].each do |node|
        if tree_walk[:children][node.id]
          if path.end_node == node
            new_hash = {}
            if path.last_relationship
              new_hash[:type] = path.last_relationship.rel_type
            end
            new_hash[:id] = node.id
            tree_walk[:children][node.id] = new_hash
          end
        else
          tree_walk[:children].merge!({ node.id => { :children => {}}})
        end

        if path.end_node == node
          new_hash = {}
          if path.last_relationship
            new_hash[:type] = path.last_relationship.rel_type
          end
          tree_walk[:children][node.id].merge!(new_hash)
        end

        tree_walk = tree_walk[:children][node.id]
      end
    end
    tree_hash
  end
end
