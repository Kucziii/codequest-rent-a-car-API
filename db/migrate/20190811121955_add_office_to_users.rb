class AddOfficeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :office_id, :bigint
  end
end
