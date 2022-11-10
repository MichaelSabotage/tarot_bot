class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :phone
      t.date :birth_date
      t.string :profession
      t.string :family_status
      t.integer :children_count
      t.boolean :admin, default: false

      t.timestamps
    end
  end
end
