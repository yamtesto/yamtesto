class AddActivationTagToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :activation_tag, :string
  end

  def self.down
    remove_column :users, :activation_tag
  end
end
