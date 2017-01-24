require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Collection < Request
		attr_accessor :name,
									:id,
									:description,
									:products

		def initialize(attributes)

			if !attributes.nil?
				@id = attributes['id']
				@name = attributes['name']
				@description = attributes['description']
				@products = attributes['items'].map { |item| Marketcloud::Product.new(item) }
			end
		end


		# Find a collection by ID
		# @param id [Integer] the ID of the collection
		# @return a Collection
		def self.find(id)
			collection = perform_request api_url("collections/#{id}")

			if collection
				new collection['data']
			else
				nil
			end
		end

		# Return all the collections
		# @return an array of Collections
		def self.all()
			collections = perform_request(api_url("collections"), :get, nil, true, {})

			if collections
				collections['data'].map { |c| new(c) }
			else
				nil
			end
		end

	end
end
