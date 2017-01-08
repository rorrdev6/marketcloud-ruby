require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::Address do

	let(:user_id)    { 107227 }
  let(:addr_name)  { "Pinco Pallo" }
	let(:addr_id)    { 107234 }

	describe 'a GET on a valid address' do
	  let(:address) { VCR.use_cassette('address') { Marketcloud::Address.find(addr_id) }}

		it 'should return 200' do
			expect(address).not_to be_nil
		end

		it 'answers to find with a valid address' do
		  expect(address.full_name).to eq addr_name
		end
	end

	describe 'a GET on a valid address and a check for its valid user' do
	  let(:address) { VCR.use_cassette('address_check_user') { Marketcloud::Address.find_and_check_user(addr_id, user_id) }}

		it 'should return 200' do
			expect(address).not_to be_nil
		end

		it 'answers to find with a valid address' do
		  expect(address.full_name).to eq addr_name
		end
	end

	describe 'a GET on a valid address and a check for another user' do

		it 'should raise an exception AddressNotFound' do
			expect{ VCR.use_cassette('address_check_user_ko') { Marketcloud::Address.find_and_check_user(addr_id, 10000) }}.to raise_error(Marketcloud::AddressNotFound)
		end

	end

	describe 'a GET on all addresses by a given user' do
		let(:addresses) { VCR.use_cassette('addresses') { Marketcloud::Address.find_by_user(user_id) }}

		it 'answers with an array' do
		  expect(addresses).to be_kind_of(Array)
		end

		it 'returns only addresses that belong to the user' do
			check = true

			addresses.each { |addr| check &&= (addr.user_id == user_id) }

		  expect(check).to be true
		end
	end

	describe 'a POST for a new address' do
    let(:address) {
      VCR.use_cassette('address_creation') {
        user = Marketcloud::User.find_by_email('prova2@prova.it')
        Marketcloud::Address.create(
                        {
                          full_name: "Pinco Pallo",
                          user_id: user.id,
                          email: "pinco@pallo.com",
                          country: "Italy",
                          city: "Milano",
                          address1: "Via Vittor Pisani 13",
                          postal_code: "20127"
                        })
      }
    }

    it 'should return 200' do
      expect(address).not_to be_nil
    end

    it 'should be a valid address' do
      expect(address.email).to eq "pinco@pallo.com"
    end
	end

  describe 'a PUT on an existing address' do
    let(:address) {
      VCR.use_cassette('address_update') {
        addr = Marketcloud::Address.find(addr_id)
        addr.update!(
                        {
                          full_name: "Pinco Pallo",
                          user_id: user_id,
                          email: "pinco@pallo.com",
                          country: "Norway",
                          city: "Oslo",
                          address1: "Via Vittor Pisani 13",
                          postal_code: "20127"
                        })
        addr
      }
    }

    it 'should return an object' do
      expect(address).not_to be_nil
    end

    it 'should be an updated address' do
      expect(address.country).to eq "Norway"
    end
	end

	describe 'a DELETE on an address' do
		let(:address) {
      VCR.use_cassette('address_delete_prepare') {
				user = Marketcloud::User.find_by_email('prova2@prova.it')
        addr = Marketcloud::Address.create({
						full_name: "Pinco Pallo",
						user_id: user.id,
						email: "pinco@pallo.com",
						country: "Italy",
						city: "Milano",
						address1: "Via Vittor Pisani 13",
						postal_code: "20127"
					})
				addr
      }
    }

		let(:deleted) {
			VCR.use_cassette('address_delete') {
				deleted = Marketcloud::Address.delete(address.id)
				deleted
			}
		}

		let(:check) {
			VCR.use_cassette('address_delete_check') {
				check = Marketcloud::Address.find(address.id)
				check
			}
		}

		it 'should return an object' do
      expect(deleted).not_to be_nil
    end

		it 'should have deleted the cart' do
      expect(check).to be_nil
    end
	end
end
