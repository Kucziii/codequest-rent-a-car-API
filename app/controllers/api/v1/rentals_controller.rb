class Api::V1::RentalsController < ApplicationController
  before_action :authenticate, only: [:rent_a_car]

  def rent_a_car
    date_check
    car = Car.find(params[:car_id])
    if current_user.role == 'owner'
        if car.office_id == current_user.office_id && @rented == false
          @rental = Rental.new(rental_params)
          if @rental.save
            successful_rental(car)
          end
        elsif @rented == true
          already_rented
        elsif car.office_id != current_user.office_id
          not_matching_office_ids
        end
    else
      render status: :unauthorized
    end
  end

  private

  def date_check
    @last_rental = Rental.where(car_id: params[:car_id]).last
    if !@last_rental.nil?
      @rented = (params[:rented_from].to_s < @last_rental.rented_to.to_s)
    else
      @rented = false
    end
  end

  def successful_rental(car)
    render json: {
      customer_id: @rental.customer_id,
      car_id: @rental.car_id,
      car_make: car.make,
      car_model: car.model,
      rented_from: @rental.rented_from.as_json,
      rented_to: @rental.rented_to.as_json
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

  def rental_params
    params.permit(:customer_id, :car_id, :rented_from, :rented_to)
  end
end
