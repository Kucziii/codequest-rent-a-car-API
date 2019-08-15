class AddOfficeToCars < ActiveRecord::Migration[5.2]
  def change
    add_column :cars, :office_id, :bigint
  end
end
