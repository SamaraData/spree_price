class AddPriceToOrderAndLineItem < ActiveRecord::Migration
  def change
    create_table :spree_order_prices do |t|
      t.belongs_to :order, index: true
      t.belongs_to :price_type, index: true
      t.decimal :amount, :precision => 8, :scale => 2, :null => false

      t.timestamps
    end

    create_table :spree_line_item_prices do |t|
      t.belongs_to :line_item, index: true
      t.belongs_to :price_type, index: true
      t.decimal :amount, :precision => 8, :scale => 2, :null => false

      t.timestamps
    end
  end
end
