require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Product < Request
		attr_accessor :name, :id, :sku, :description,
									:category_id, :brand_id,
									:price, :images

		def initialize(attributes)
			@id = attributes['id']
			@name = attributes['name']
			@sku = attributes['sku']
			@description = attributes['description']
			@category_id = attributes['category_id']
			@brand_id = attributes['brand_id']
			@price = attributes['price']
			@images = attributes['images']
		end

		# Find a product by ID
		# @param id [Integer] the ID of the product
		# @return a Product or nil
		def self.find(id)
			product = perform_request api_url("products/#{id}")

			if product
				new product['data']
			else
				nil
			end
		end

		# Find all the products belonging to a category
		# @param cat_id [Integer] the category ID
		# @param published [Boolean] whether query only for published products, defaults to true
		# @return an array of Products or nil
		def self.find_by_category(cat_id, published=true)
			products = perform_request(api_url("products", { category_id: cat_id, published: published }), :get, nil, false)

			if products
				products['data'].map { |p| new(p) }
			else
				nil
			end
		end

		# Return all the products
		# @param published [Boolean] whether query only for published products, defaults to true
		# @return an array of Products#
		def self.all(published=true)
			products = perform_request(api_url("products"), :get, nil, true)

			if products
				products['data'].map { |p| new(p) }
			else
				nil
			end
		end

	end
end
