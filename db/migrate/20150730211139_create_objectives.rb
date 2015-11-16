class CreateObjectives < ActiveRecord::Migration
  def change
    create_table :objectives do |t|
      t.text :text
      t.date :start
      t.date :end
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
