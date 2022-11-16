class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user
      t.references :reading
      t.text :comment
      t.text :answer
      t.integer :price
      t.date :date
      t.string :status

      t.timestamps
    end
  end
end
