class CreateProjects < ActiveRecord::Migration
  def up
    create_table :projects do |t|
      t.integer :user_id
      t.datetime :deadline
      t.string :name
      t.text :description
      t.boolean :completed

      t.timestamps
    end

    add_column :tasks, :project_id, :integer

    add_index :projects, :user_id
  end

  def down
    drop_table :projects
  end
end
