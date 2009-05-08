class AddPasswordsToAccounts < ActiveRecord::Migration
  def self.up
    add_column(:accounts, 'password', :string, :limit => 32)
  end

  def self.down
    remove_column(:accounts, 'password')
  end
end
