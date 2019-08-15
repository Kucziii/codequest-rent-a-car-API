class Rentals < ActiveRecord::Migration[5.2]
  def change
    create_table :rentals do |t|
      t.bigint   :customer_id
      t.bigint   :car_id
      t.string   :car_make
      t.string   :car_model
      t.datetime :rented_from
      t.datetime :rented_to
    end
  end
end
