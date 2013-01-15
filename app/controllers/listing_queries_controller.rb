class ListingQueriesController < ApplicationController

  def create
    puts 'I am in ListingQueriesController>>create'
    query_hash = params[:listing_query]
    listingQ = ListingQuery.new
    listingQ.register_query(query_hash)
    render :json => "in listing queries controller!!!"
  end

end