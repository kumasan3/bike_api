class CreateBikes < ActiveRecord::Migration[5.2]
  def change
    create_table :bikes do |t|
      t.bigint :brand_id, null: false
      t.string :serial_number, null: false
      t.datetime :sold_at

      t.timestamps
    end
    add_index :bikes, :serial_number, unique: true
  end
end
