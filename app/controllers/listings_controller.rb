class ListingsController < ApplicationController

  def find
    listing = Listing.new(params[:listing])
    matches = listing.percolate_queries
    puts 'I am in ListingsController>#find'
    render :json => {"matches" =>  matches.as_json}
  end
end