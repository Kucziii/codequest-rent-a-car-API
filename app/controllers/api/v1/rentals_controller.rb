class Api::V1::RentalsController < ApplicationController
  before_action :authenticate, only: [:rent_a_car]

  def rent_a_car
    date_check
    car = Car.find(params[:car_id])
    if current_user.role == 'owner'
        if car.office_id == current_user.office_id && @rented == false && valid_customer? 
          rental = Rental.new(rental_params)
          if rental.save
            successful_rental(car, rental)
          end
        elsif @rented == true 
          already_rented
        elsif car.office_id != current_user.office_id
          not_matching_office_ids
        elsif valid_customer? == false
          wrong_customer
        end
    else
      render status: :unauthorized
    end
  end

  private

  def date_check
    @rented = false
    last_rentals = Rental.where("rented_to > :time and car_id = :carId",
                               { time: DateTime.now, carId: params[:car_id] })
    time_ranges = []
    last_rentals.each do |range|
      time_ranges << [range.rented_from.to_i, range.rented_to.to_i]
    end
    
    rented_from = DateTime.parse(params[:rented_from]).to_i
    rented_to = DateTime.parse(params[:rented_to]).to_i
    time_ranges.each do |check|
      first_date = rented_from.between?(check[0],check[1])
      second_date = rented_to.between?(check[0],check[1])
      if first_date == true || second_date == true
        @rented = true
      end
    end
  end

  def valid_customer?
    if User.exists?(params[:customer_id])
      customer = User.find(params[:customer_id])
      customer.role == "customer" ? true : false
    else
      false
    end
  end

  def successful_rental(car, rental)
    render json: {
      customer_id: rental.customer_id,
      car_id: rental.car_id,
      car_make: car.make,
      car_model: car.model,
      rented_from: rental.rented_from.as_json,
      rented_to: rental.rented_to.as_json
    }
  end

  def already_rented
    render status: :unprocessable_entity,
           json: '"The car is already rented to someone else!"'
  end

  def not_matching_office_ids
    render status: :unprocessable_entity,
           json: '"The car must belong to your office!"'
  end

  def wrong_rental_params
    render status: :unprocessable_entity,
           json: '"Please provide valid customer!"'
  end

  def wrong_customer
    render status: :unprocessable_entity,
           json: '"Please provide valid customer"'
  end

  def rental_params
    params.permit(:customer_id, :car_id, :rented_from, :rented_to)
  end
end
