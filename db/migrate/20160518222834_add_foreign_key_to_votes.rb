class AddForeignKeyToVotes < ActiveRecord::Migration
  def change
    add_foreign_key :votes, :users
  end
end
