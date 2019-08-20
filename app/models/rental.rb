class Rental < ApplicationRecord

  # Validations
  validates :customer_id, presence: true
  validates :car_id, presence: true
  validates :rented_from, presence: true
  validates :rented_to, presence: true
end
