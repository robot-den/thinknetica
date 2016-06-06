class AddConfirmedToAuthorization < ActiveRecord::Migration
  def change
    add_column :authorizations, :confirmation_hash, :string
    add_column :authorizations, :confirmed, :boolean, default: false
  end
end
