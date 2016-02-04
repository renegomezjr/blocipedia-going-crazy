class AddCustomeridToUsers < ActiveRecord::Migration
  def change
    add_column :users, :customerid, :string
  end
end
