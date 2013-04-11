class CreateInvites < ActiveRecord::Migration
  def up
    create_table :invites do |t|
      t.string :email
      t.integer :user_id
      t.integer :group_id
      t.timestamps
    end
  end

  def down
    drop_table :invites
  end
end
