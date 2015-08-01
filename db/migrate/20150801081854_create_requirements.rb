class CreateRequirements < ActiveRecord::Migration
  def change
    create_table :requirements do |t|
      t.float :score
      t.string :text
      t.text :description
      t.integer :objective_id
    end

    add_column :objectives, :score, :float
  end
end
