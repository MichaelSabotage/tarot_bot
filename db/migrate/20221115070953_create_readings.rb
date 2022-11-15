class CreateReadings < ActiveRecord::Migration[7.0]
  def change
    create_table :readings do |t|
      t.string :name
      t.text :description
      t.references :topic
      t.integer :basic_price
      t.integer :processing_time

      t.timestamps
    end
  end
end
