class ChangeBirthdateTypeForUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
#      t.change :birth_date, :datetime
    end
  end

  def self.down
    change_table :users do |t|
#      t.change :birth_date, :string
    end
  end
end
