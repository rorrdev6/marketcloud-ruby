require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Shipping < Request
		attr_accessor :name,
									:id,
									:base_cost,
									:per_item_cost,
									:zones,
									:max_weight,
									:min_weight,
									:max_depth,
									:min_depth,
									:max_height,
									:min_height,
									:max_width,
									:min_width,
									:max_value,
									:min_value


		#
		#
		#
		def initialize(attributes)
			@id = attributes['id']
			@name = attributes['name']
			@per_item_cost = attributes['per_item_cost']
			@zones = attributes['zones']
			@base_cost = attributes['base_cost']
			@max_weight = attributes['max_weight'] || 10000000000
			@min_weight = attributes['min_weight'] || 0
			@max_depth = attributes['max_depth'] || 0
			@min_depth = attributes['min_depth'] || 0
			@max_height = attributes['max_height'] || 0
			@min_height = attributes['min_height'] || 0
			@max_width = attributes['max_width'] || 0
			@min_width = attributes['min_width'] || 0
			@max_value = attributes['max_value'] || 0
			@min_value = attributes['min_value'] || 0
		end

		# Find a shipping by ID
		# @param id [Integer] the ID of the shipping
		# @return a Shipping or nil
		def self.find(id)
			shipping = perform_request api_url("shippings/#{id}")

			if shipping
				new shipping['data']
			else
				nil
			end
		end



		# Return all the shippings
		# @return an array of Shippings
		def self.all()
			shippings = perform_request(api_url("shippings"), :get, nil, true)

			if shippings
				shippings['data'].map { |p| new(p) }
			else
				nil
			end
		end

	end
end
