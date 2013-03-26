class CreateTasks < ActiveRecord::Migration
  def up
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.integer :user_id
      t.datetime :deadline
      t.boolean :repeatable
      t.string :repeat_type
      t.boolean :completed

      t.timestamps
    end
  end

  def down
    drop_table :tasks
  end
end
