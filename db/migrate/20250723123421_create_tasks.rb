class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.references :child, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :time_of_day, default: 1  # afternoon
      t.string :frequency, default: 'daily'
      t.string :specific_days
      t.boolean :active, default: true
      t.timestamps
    end
    add_index :tasks, [:child_id, :active]
    add_index :tasks, :time_of_day
  end
end
