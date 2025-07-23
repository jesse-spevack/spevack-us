class CreateTaskCompletions < ActiveRecord::Migration[8.0]
  def change
    create_table :task_completions do |t|
      t.references :task, null: false, foreign_key: true
      t.date :completed_on, null: false
      t.timestamps
    end
    add_index :task_completions, [:task_id, :completed_on], unique: true
    add_index :task_completions, :completed_on
  end
end
