require 'mysql'
require 'digest/md5'

class Account < ActiveRecord::Base
  attr_accessor :change_password, :password_confirmation

  has_many :list_positions, :dependent => :destroy
  has_many :characters, :dependent => :destroy
  has_many :signups, :through => :characters
  has_many :raids, :dependent => :destroy

  # Make sure all characters can be deleted
  before_destroy :can_delete?

  named_scope(:admins,
              :include => { :characters => [:account, :cclass, :race] },
              :conditions => { :admin => true },
              :order => "accounts.name, characters.level desc, characters.name")

  named_scope(:members,
              :include => { :characters => [:account, :cclass, :race] },
              :conditions => { :admin => false },
              :order => "accounts.name, characters.level desc, characters.name")

  @@mysql = nil

  validates_uniqueness_of :name
  validates_presence_of :name

  def validate
    if CONFIG[:auth] == 'login'
      unless password_confirmation == change_password
        errors.add_to_base('Password and Password Confirmation must match to change your password')
      end

      if new_record? and change_password.blank?
        errors.add_to_base("Password can't be blank")
      end
    end
  end

  def signup_stats
    total_raids = Raid.past.count
    last_month_raids = Raid.last_month.past.count
    last_three_months_raids = Raid.last_three_months.past.count

    counts = {
      :raids => {
        :title => 'Raids',
        '30' => last_month_raids,
        '90' => last_three_months_raids },
      :signed => {
        :title => 'Signed Up',
        '30' => self.signups.past.last_month.count(:group => 'signups.raid_id').size,
        '90' => self.signups.past.last_three_months.count(:group => 'signups.raid_id').size },
      :not_signed => {
        :title => 'Did Not Sign up',
        '30' => last_month_raids - self.signups.past.last_month.count(:group => 'signups.raid_id').size,
        '90' => last_three_months_raids - self.signups.past.last_three_months.count(:group => 'signups.raid_id').size },
      :seated => {
        :title => 'Seated',
        '30' => self.signups.seated.past.last_month.count(:group => 'signups.raid_id').size,
        '90' => self.signups.seated.past.last_three_months.count(:group => 'signups.raid_id').size } }
  end

  def no_shows
    last_month_counts = self.signups.past.last_month.count(:group => :no_show)
    last_three_months_counts = self.signups.past.last_three_months.count(:group => :no_show)

    counts = Signup::NO_SHOW_OPTIONS.inject({}) do |hash, option|
      hash.merge({ option => {
          '30' => last_month_counts[option] || 0,
          '90' => last_three_months_counts[option] || 0 } })
    end

    counts['Total No Shows'] = {
      '30' => counts['No Notice']['30'] + counts['Advance Notice']['30'],
      '90' => counts['No Notice']['90'] + counts['Advance Notice']['90'] }

    return counts
  end

  # Return true if this account is able to edit this raid
  def can_edit?(raid)
    self.admin or self == raid.account
  end

  def can_delete?
    characters.map do |c|
      c.can_delete?
    end.all?
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
      account.save(false)

      return account
    end
  end

  def Account.mysql
    @@mysql ||= Mysql.new(CONFIG[:phpbb_host],
                          CONFIG[:phpbb_user],
                          CONFIG[:phpbb_pass],
                          CONFIG[:phpbb_db],
                          CONFIG[:phpbb_post].to_i)
  end

  def before_save
    if CONFIG[:auth] == 'login' && (not change_password.blank?)
      self[:password] = Digest::MD5.hexdigest(change_password)
    end
  end
end
