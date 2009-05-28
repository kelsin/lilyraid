require 'mysql'
require 'digest/md5'

class Account < ActiveRecord::Base
  attr_accessor :change_password, :password_confirmation

  has_many :list_positions
  has_many :characters, :dependent => :destroy

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

  validates_uniqueness_of :name
  validates_presence_of :name

  def validate
    unless password_confirmation == change_password
      errors.add_to_base('Password and Password Confirmation must match to change your password')
    end

    if new_record? and change_password.blank?
      errors.add_to_base('Password can\'t be blank')
    end      
  end

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
         :include => { :characters => [:account, :cclass, :race] },
         :conditions => ["accounts.admin = ?", true],
         :order => "accounts.name, characters.level desc, characters.name")
  end
  
  def self.members
    find(:all,
         :include => { :characters => [:account, :cclass, :race] },
         :conditions => ["accounts.admin = ?", false],
         :order => "accounts.name, characters.level desc, characters.name")
  end
  
  def Account.get_account_id_from_info(username, password)
    account = find(:first,
                   :conditions => ['name = ? and password = md5(?)', username, password])
    account ? account.id : nil
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

  def before_save
    if CONFIG[:auth] == 'login' && (not change_password.blank?)
      self[:password] = Digest::MD5.hexdigest(change_password)
    end
  end
end
