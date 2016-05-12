class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.belongs_to :user
      t.integer :votable_id
      t.string :votable_type
      t.integer :value
      t.timestamps null: false
    end

    add_index :votes, [:user_id, :votable_id, :votable_type], unique: true
  end
end
