class AddIndexToJobs < ActiveRecord::Migration
  def self.up
    add_index :jobs, [ :company, :title ], :unique => true, :name => 'by_company_and_title'
    add_index :jobs_users, [ :job_id, :user_id ], :unique => true, :name => 'by_job_and_user'
  end

  def self.down
    remove_index :jobs, 'by_company_and_title'
    remove_index :jobs_users, 'by_job_and_user'
  end
end
