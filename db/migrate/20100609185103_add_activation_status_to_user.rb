class AddActivationStatusToUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :activated
    add_column :users, :activated, :integer
  end

  def self.down
    remove_column :users, :activated
    add_column :users, :activated, :boolean
  end
end
