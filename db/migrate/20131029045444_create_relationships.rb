class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    add_index :relationshipss, :follower_id
    add_index :relationshipss, :followed_id
    add_index :relationshipss, [:follower_id, :followed_id], unique: true
  end
end
