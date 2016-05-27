class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.belongs_to :user
      t.integer :commentable_id
      t.string :commentable_type
      t.string :body, null: false
      t.timestamps null: false
    end
    add_foreign_key :comments, :users
    add_index :comments, :user_id
  end
end
