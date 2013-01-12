require 'tire'
require 'time'
require 'uri'
require 'tire'
require 'pry'
require 'rubygems'
#require '/home/move/Documents/stash/ESWResources/app/models/query_parser.rb'
#require '/home/move/Documents/stash/ESWResources/app/models/listing_query.rb'
require 'query_parser.rb'
require 'listing_query.rb'

class Listing
  def initialize(attributes={})
    @attributes = attributes
    @attributes.each_pair { |name, value| instance_variable_set :"@#{name}", value}
  end

  def to_indexed_json
    @attributes.to_json
  end

  def type
    @attributes[:resource_type]
  end

  def percolate_queries
    matches = ListingQuery.listing_index.percolate(self)
    matches
  end
end

#lat1 = 40.12; lon1 = -71.34
#new_listing = Listing.new :id => '6',
#                          :resource_type => "listing",
#                          :address => "7009 Fellsway Cove",
#                          :beds => 3,
#                          :baths =>  2,
#                          :zip => "38125",
#                          :location => {:lat => lat1.to_f, :lon => lon1.to_f},
#                          :price =>  140000,
#                          :comment => "this is a comment"
#
#matches = new_listing.percolate_queries
#puts '-----------------------'
#puts matches.inspect
#puts '-----------------------'





