require 'spec_helper'
#debugger

resource "Lqs" do
  let(:raw_post) {params.to_json}
  post '/lqs/create' do
    parameter :listing_query, "Register a listing query"

    let(:listing_query) {
      {query:
          [{beds: ["long", [1,3]]},
           {zip: ["string", ["38119", "38125"]]},
           {location: ["geopoint", [40, -70, "120km"]]},
           {price:  ["long", [140000, 200000]]}
          ],
        resource_type: "listing",
        query_id: "memberID1-q1"
      }
    }


    example "Create a new listing query" do
      #debugger
      do_request
      status.should == 200
    end

  end

end

#resource "Listings" do
#  let(:raw_post) {params.to_json}
#  post '/listings/find' do
#    #let(:raw_post) {params.to_json}
#    parameter :listing, "Register a listing query"
#    let(:listing) {
#      {
#          id: "listing_id1",
#          resource_type: "listing",
#          address: "7009 Fellsway Cove",
#          beds: 3,
#          baths:2,
#          zip: "38125",
#          location: {lat: 40.12, lon: -71.34},
#          price:  140000,
#          comment: "this is a comment"
#      }
#    }
##
#    example "Percolate a listing to find matches" do
#      #debugger
#      do_request
#      status.should == 200
#    end
#    #
#  end
#end