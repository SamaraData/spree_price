class AddDefaultForRole < ActiveRecord::Migration
  def change
    remove_column :spree_price_types, :priority, :number
    add_column :spree_price_types, :default, :boolean, default: false, null: false
    add_column :spree_roles, :default, :boolean, default: false, null: false
  end
end
