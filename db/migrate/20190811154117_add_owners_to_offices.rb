class AddOwnersToOffices < ActiveRecord::Migration[5.2]
  def change
    add_column :offices, :owner_id, :bigint
  end
end
