class RemoveRentedFromCars < ActiveRecord::Migration[5.2]
  def change
    remove_column :cars, :rented_from, :datetime
    remove_column :cars, :rented_to, :datetime
  end
end
