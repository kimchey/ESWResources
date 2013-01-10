require 'tire'
require 'time'
require 'uri'
require 'tire'
require 'pry'
require 'rubygems'
require 'query_parser.rb'


class ListingQuery

  def self.create_idx
    @@listing_idx = Tire.index 'listing' do
      create :mappings => {
          :listing => {
              :properties => {
                  :id => { :type => 'string'},
                  :resource_type => {:type => 'string'},
                  :address => {:type => 'string'},
                  :zip => {:type => 'string'},
                  :beds => {:type => 'long'},
                  :baths => {:type => 'long'},
                  :location => {:type => 'geo_point'},
                  :price => {:type => 'long'},
                  :comment => {:type => 'string'}
              }
          }
      }
    end
  end

  def self.listing_index
    self.create_idx unless (class_variable_defined?(:@@listing_idx) and !@@listing_idx.nil?)
    return @@listing_idx
  end

  def initialize(attributes={})
    @attributes = attributes
    @attributes.each_pair { |name, value| instance_variable_set :"@#{name}", value}
  end

  def elasticsearch_query(query_hash={})
    qp = ESQueryParser.new(query_hash)
    query = qp.parse
    query
  end

  def register_query(query_hash)
    saved_query = elasticsearch_query(query_hash)
    query_name = query_hash[:query_id]
    ListingQuery.listing_index.register_percolator_query(query_name)  do |q|
      q.filtered do
        query {all}
        filter(:and, saved_query)
      end
    end
    Tire.index('_percolator').refresh
  end

end

#query_hash = {"query" =>
#                  [{"beds" => ["long", [1,3]]},
#                   {"zip" => ["string", ["38119", "38125"]]},
#                   {"location" => ["geopoint", [40, -70, "1200km"]]},
#                   {"price" => ["long", [140000, 200000]]}
#                   #{"address" => ["string", ["7009 Fellsway Cove"]]}
#                   #{"comment" => ["string", ["this is a comment"]]}
#                  ],
#              "resource_type" => "listing"
#            }
#
#a_listingQ = ListingQuery.new
#a_listingQ.register_query("q2", query_hash)


