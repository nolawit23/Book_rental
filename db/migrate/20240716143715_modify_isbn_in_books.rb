class ModifyIsbnInBooks < ActiveRecord::Migration[7.0]
  def change
    change_column :books, :isbn, :string, limit: 13
  end
end
