class LqsController < ApplicationController

  def create
    #debugger
    puts 'I am in create'
    #debugger
    query_hash = params[:listing_query]
    listingQ = Lq.new
    listingQ.register_query(query_hash)
    render :json => "in listing queries controller!!!"
  end

end