class AddRentedToCars < ActiveRecord::Migration[5.2]
  def change
    add_column :cars, :rented_from, :datetime
    add_column :cars, :rented_to, :datetime
  end
end
