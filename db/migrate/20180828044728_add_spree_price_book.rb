class AddSpreePriceBook < ActiveRecord::Migration
  def change
    create_table :spree_price_books do |t|
      t.datetime :active_from
      t.datetime :active_to
      t.string :currency, index: true
      t.string :name
      t.float :price_adjustment_factor
      t.integer :lft, index: true
      t.integer :rgt, index: true
      t.integer :depth, index: true
      t.references :parent, index: true, references: :spree_price_books
      t.belongs_to :price_type, index: true

      t.timestamps
    end

    add_reference :spree_prices, :price_book, index: true
    add_index :spree_prices, [:variant_id, :price_book_id]

    create_table :spree_store_price_books do |t|
      t.belongs_to :price_book, index: true
      t.belongs_to :store, index: true
      t.integer :priority, default: 0, null: false, index: true

      t.timestamps
    end

    create_table :spree_role_price_books do |t|
      t.belongs_to :price_book, index: true
      t.belongs_to :role, index: true

      t.timestamps
    end

    create_table :spree_currency_rates do |t|
      t.string :base_currency
      t.string :currency
      t.boolean :default, null: false, default: false, index: true
      t.float :exchange_rate
      t.timestamps
    end

    create_table :spree_price_types do |t|
      t.string :name
      t.string :code
      t.integer :priority, default: 0, null: false, index: true

      t.timestamps
    end
  end
end
