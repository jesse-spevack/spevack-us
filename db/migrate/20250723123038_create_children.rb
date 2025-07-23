class CreateChildren < ActiveRecord::Migration[8.0]
  def change
    create_table :children do |t|
      t.string :name, null: false
      t.string :theme, default: 'default'
      t.timestamps
    end
  end
end
