require 'tire'
require 'time'
require 'uri'
require 'tire'
require 'pry'
require 'rubygems'

class ESQueryParser

  def initialize(hash)
    @input_hash = hash
    @idx_type = hash["resource_type"]
  end

  def idx_type
    @idx_type
  end

  def type
    @idx_type
  end

  def idx
    Tire::index @idx_type
  end

  def mapping
    self.idx.mapping
  end

  def create_mapping(field, field_type)
    debugger
    idx_t = @idx_type
    idx_sym = idx_t.to_sym
    field_sym = field.to_sym
    Tire.index idx_t do
      debugger
      create :mappings => {
          idx_sym => {
              :properties => {
                  field_sym => {:type => field_type}
              }
          }
      }
    end
  end

  def parse
    @query = []
    arr_val = @input_hash["query"]
    arr_val.each do |a_hash|
      a_hash.each do |key, value|
        method = "parse_#{value[0]}".to_sym
        self.send method, key, value
      end
    end
    @query
  end

  def parse_long(key, value)
    q =  value.length > 1 ?
        {:range => {key.to_sym => {:from => value[1][0], :to => value[1][1]}}} :
        {:term => {key.to_sym => value[1][0]}}
    @query << q
  end

  def parse_string(key, value)
    q = value[1].length > 1 ?
                {:terms => {key.to_sym => value[1]}} :
                {:term => {key.to_sym => value[1][0]}}  #does not work for string
    @query << q
  end

  def parse_text(key, value)
    q = {:query => {:match => {key.to_sym => value[1][0]}}}
    @query << q
  end

  def parse_geopoint(key, value)
    q = {:geo_distance => {:distance => value[1][2],key.to_sym => [value[1][1].to_f, value[1][0].to_f]}}
    @query << q
  end

end
=begin
query_hash = {"query" =>
                  [{"beds" => ["long", [1,3]]},
                   {"zip" => ["string", ["38119", "38125"]]},
                   {"location" => ["geopoint", [40, 70, "120km"]]},
                   {"price" => ["long", [140000, 200000]]},
                   {"address" => ["string", ["7009 Fellsway Cove"]]},
                   {"comment" => ["string", ["this is a comment"]]}
                  ]
             }
#debugger
qp = ESQueryParser.new(query_hash)
query = qp.parse

puts query
=end
