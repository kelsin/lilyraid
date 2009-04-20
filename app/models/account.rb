require 'mysql'

class Account < ActiveRecord::Base
  has_many :list_positions
  
  has_many(:characters,
           :dependent => :nullify,
           :order => "characters.name",
           :include => [{:cclass => :roles},
                        :instances,
                        :raids])
  has_many(:active_characters,
           :class_name => "Character",
           :order => "characters.name",
           :conditions => ["characters.inactive = ?", false],
           :include => [{:cclass => :roles},
                        :instances,
                        :raids]) do
    def can_join(raid)
      if raid.instance.requires_key
        find(:all,
             :include => :instances,
             :conditions => ["instances.id = ? and characters.level >= ? and characters.level <= ?", raid.instance.id, raid.min_level, raid.max_level]) - raid.characters
      else
        find(:all,
             :conditions => ["characters.level >= ? and characters.level <= ?", raid.min_level, raid.max_level]) - raid.characters
      end
    end
  end
  
  has_many(:old_signups,
           :class_name => "Signup",
           :include => :raid,
           :through => :characters,
           :conditions => ["raids.date < now()"]) do
    def old_raids
      proxy_target.collect(&:raid).uniq
    end
  end
  has_many(:signups,
           :include => :raid,
           :through => :characters) do
    def raid(id)
      find(:all,
           :include => :raid,
           :conditions => ["raid_id = ?", id])
    end
    def raids
      proxy_target.collect(&:raid).uniq
    end
  end
  has_many :raids, :class_name => "Raid", :dependent => :destroy
  has_one(:closest_raid,
          :class_name => 'Raid',
          :order => 'date',
          :conditions => 'date >= NOW()')

  before_destroy :can_delete

  @@mysql = nil
  
  def characters_that_can_join(raid)
    characters.select do |character|
      character.can_join(raid)
    end
  end

  def can_edit(raid)
    self.admin or self == raid.account
  end

  def can_delete
    characters.select do |c|
      !c.can_delete
    end.empty?
  end

  def lj_link
    "http://#{lj_account}.livejournal.com/" if lj_account
  end

  def self.admins
    find(:all,
         :include => { :active_characters => [:account, :cclass, :race] },
         :conditions => ["accounts.admin = ?", true],
         :order => "accounts.name, characters.level desc, characters.name")
  end
  
  def self.members
    find(:all,
         :include => { :active_characters => [:account, :cclass, :race] },
         :conditions => ["accounts.admin = ?", false],
         :order => "accounts.name, characters.level desc, characters.name")
  end
  
  def Account.get_account_id_from_info(username, password)
    phpbb_prefix = CONFIG[:phpbb_prefix] || ""

    user_id_sql = "select user_id
                         from #{phpbb_prefix}users
                        where username = '#{username}'
                          and user_password = MD5('#{password}')"
    
    mysql.query(user_id_sql) do |user_id_result|
      user_id_result.each_hash do |user_id_row|
        return user_id_row["user_id"]
      end
    end
    
    return nil
  end
  
  def Account.get_account_id_from_sid(sid)
    phpbb_prefix = CONFIG[:phpbb_prefix] || ""
    
    # Get User Id
    user_id_sql = "select session_user_id
                         from #{phpbb_prefix}sessions
                        where #{phpbb_prefix}sessions.session_id = '#{sid}'"
    
    mysql.query(user_id_sql) do |user_id_result|
      user_id_result.each_hash do |user_id_row|
        return user_id_row["session_user_id"]
      end
    end
    
    return nil
  end

  def update_info
    phpbb_prefix = CONFIG[:phpbb_prefix] || ""
    admin_group_id = CONFIG[:phpbb_admin_group]

    user_info_sql = "select username,
                                user_email
                           from #{phpbb_prefix}users
                          where user_id = #{id}"
    
    Account.mysql.query(user_info_sql) do |user_info|
      user_info.each_hash do |user_info_row|
        self.name = user_info_row["username"]
        self.email = user_info_row["user_email"]
      end
    end

    group_sql = "select 1
                       from #{phpbb_prefix}user_group
                      where user_id = #{id}
                        and group_id = #{admin_group_id}"

    self.admin = false
    Account.mysql.query(group_sql) do |admin_info|
      admin_info.each_hash do |admin_info_row|
        self.admin = true
      end
    end
    
    self.save
    
    return self
  end
  
  def Account.get_account_from_id(account_id)
    if Account.exists?(account_id)
      return Account.find(account_id)
    else
      # Create an account for this user
      account = Account.new
      account.id = account_id
      account.admin = false
      account.save
      
      return account
    end
  end
  
  def Account.mysql
    unless @@mysql
      phpbb_db = CONFIG[:phpbb_db]
      phpbb_host = CONFIG[:phpbb_host]
      phpbb_user = CONFIG[:phpbb_user]
      phpbb_pass = CONFIG[:phpbb_pass]
      phpbb_port = CONFIG[:phpbb_port].to_i
      @@mysql = Mysql.new(phpbb_host, phpbb_user, phpbb_pass, phpbb_db, phpbb_port)
    end
    
    @@mysql
  end
end
