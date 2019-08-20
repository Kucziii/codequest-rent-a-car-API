require 'rails_helper'
RSpec.describe 'POST /office/:office_id/rentals', type: :request do
  let(:customer) { create :customer }
  let(:office) { create :office }
  let(:owner) { create :owner, office_id: office.id }
  let(:car) { create :car, office_id: office.id }
  let(:rented_from) { DateTime.now + 1.day }
  let(:rented_to) { DateTime.now + 8.days }

  let(:action) do
    post '/rentals', params: params, headers: headers
  end

  let(:params) do
    {
      car_id:      car.id,
      customer_id: customer.id,
      rented_from: rented_from,
      rented_to:   rented_to
    }
  end

  context 'when user is not authenticated' do
    let(:headers) { {} }

    it 'does not create a Rental' do
      expect { action }.to_not change { Rental.count }
    end

    it 'returns Unauthorized status' do
      action
      expect(response.status).to eq(401)
    end
  end # user not authenticated

  context 'when user is authenticated' do
    let(:token) { Knock::AuthToken.new(payload: {sub: owner.id}).token }
    let(:headers) { {'Authorization': "Bearer #{token}"} }

    context "when the car belongs to the Owner's office" do
      it 'creates a Rental' do
        expect { action }.to change { Rental.count }.by(1)
      end

      it 'returns rental data' do
        action
        expect(JSON.parse(response.body)).to eq(
          'customer_id' => customer.id,
          'car_id' =>      car.id,
          'car_make' =>    car.make,
          'car_model' =>   car.model,
          'rented_from' => Rental.last.rented_from.as_json,
          'rented_to' =>   Rental.last.rented_to.as_json
        )
      end
    end # office valid

    context 'when the car belongs to some other office' do
      let(:other_office) { create :office }
      let(:car) { create :car, office_id: other_office.id }

      it 'does not create a Rental' do
        expect { action }.to_not change { Rental.count }
      end

      it 'returns 422 status' do
        action
        expect(response.status).to eq(422)
      end

      it 'returns error' do
        action
        expect(JSON.parse(response.body)).to eq('The car must belong to your office!')
      end
    end # office invalid

    context 'when the car is already rented' do
      let(:other_customer) { create :customer }
      before do # create rentals to check if new date_check works in both cases
        create(
          :rental,
          customer_id:    other_customer.id,
          car_id:         car.id,
          rented_from: rented_from - 1.day,
          rented_to:   rented_from + 1.day
        )
        create(
          :rental,
          customer_id:    other_customer.id,
          car_id:         car.id,
          rented_from: rented_to - 1.day,
          rented_to:   rented_to + 1.day
        )
      end

      it 'does not create a Rental' do
        expect { action }.to_not change { Rental.count }
      end

      it 'returns 422 status' do
        action
        expect(response.status).to eq(422)
      end

      it 'returns error' do
        action
        expect(JSON.parse(response.body)).to eq('The car is already rented to someone else!')
      end
    end # car already rented

    context 'when customer_id is wrong' do
      let(:params) do
        {
          car_id:      car.id,
          customer_id: 9999,
          rented_from: rented_from,
          rented_to:   rented_to
        }
      end

      it 'does not create a Rental' do
        expect { action }.to_not change { Rental.count }
      end

      it 'returns error' do
        action
        expect(JSON.parse(response.body)).to eq('Please provide valid customer')
      end
    end # customer_id is wrong

    context 'when customer is an owner' do
      let(:owner_customer) { create :owner }
      let(:params) do
        {
          car_id:      car.id,
          customer_id: owner_customer.id,
          rented_from: rented_from,
          rented_to:   rented_to
        }
      end

      it 'does not create a Rental' do
        expect { action }.to_not change { Rental.count }
      end
    end # customer is owner

    context 'when no customer is passed' do
      let(:params) do
        {
          car_id:      car.id,
          rented_from: rented_from,
          rented_to:   rented_to
        }
      end

      it 'does not create a Rental' do
        expect { action }.to_not change { Rental.count }
      end
    end
  end # user authenticated
end
