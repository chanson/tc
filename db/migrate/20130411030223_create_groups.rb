class CreateGroups < ActiveRecord::Migration
  def up
    create_table :groups do |t|
      t.timestamps
      t.integer :owner_id
      t.string :name
      t.string :logo_image_uid
      t.string :logo_image_name
    end

    create_table :groups_users do |t|
      t.integer :group_id
      t.integer :user_id
    end

    add_column :projects, :group_id, :integer
    add_column :tasks, :group_id, :integer

    # create_table :groups_tasks do |t|
    #   t.integer :group_id
    #   t.integer :task_id
    # end

    # create_table :groups_projects do |t|
    #   t.integer :groups_tasks
    #   t.integer :project_id
    # end
  end

  def down
    drop_table :groups
    drop_table :groups_users
    # drop_table :groups_tasks
    # drop_table :groups_projects
  end
end
