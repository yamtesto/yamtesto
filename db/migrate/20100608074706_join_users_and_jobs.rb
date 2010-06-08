class JoinUsersAndJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs_users, :id => false do |t|
      t.references :job
      t.references :user
    end
  end

  def self.down
    drop_table :jobs_users
  end
end
