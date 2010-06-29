class Account < ActiveRecord::Base
  attr_accessor :change_password, :password_confirmation

  has_many :list_positions, :dependent => :destroy
  has_many :characters, :dependent => :destroy
  has_many :signups, :through => :characters
  has_many :raids, :dependent => :destroy

  has_many :raider_tags
  has_many :tags, :through => :raider_tags
  has_many :logs, :dependent => :destroy

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

  def self.named(name)
    self.first(:conditions => { :name => name })
  end

  def self.orphins
    phpbb_prefix = CONFIG[:phpbb_prefix] || ""

    self.all.select do |a|
      user_info_sql = "select 1
                         from #{phpbb_prefix}users
                        where username = '#{a.name}'"

      num_rows = 0
      Account.mysql.query(user_info_sql) do |result|
        num_rows = result.num_rows
      end

      num_rows == 0
    end
  end

  def signed_up_for(raid)
    !(raid.signups.select do |signup|
        signup.character.account == self
      end.empty?)
  end

  def seated_for(raid)
    !(raid.slots.select do |slot|
        slot.signup and slot.signup.character.account == self
      end.empty?)
  end

  def to_s
    self.name
  end

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

  def Account.get_account_from_phpbb(sid)
    phpbb_prefix = CONFIG[:phpbb_prefix] || ""

    # Get User Id
    username_sql = "select u.username
                      from #{phpbb_prefix}sessions s
                      join #{phpbb_prefix}users u on (u.user_id = s.session_user_id)
                     where s.session_id = '#{sid}'"

    Rails.logger.info username_sql

    username = nil
    mysql.query(username_sql) do |username_result|
      username_result.each_hash do |username_row|
        username = username_row["username"]
      end
    end

    # Find or create Account
    return username ? Account.find_or_create_by_name(username).update_info : nil
  end

  def update_info
    phpbb_prefix = CONFIG[:phpbb_prefix] || ""
    admin_group_id = CONFIG[:phpbb_admin_group]

    user_info_sql = "select user_email
                       from #{phpbb_prefix}users
                      where username = '#{self.name}'"

    Account.mysql.query(user_info_sql) do |user_info|
      user_info.each_hash do |user_info_row|
        self.email = user_info_row["user_email"]
      end
    end

    group_sql = "select 1
                   from #{phpbb_prefix}user_group g
                   join #{phpbb_prefix}users u on (u.user_id = g.user_id)
                  where u.username = '#{self.name}'
                    and g.group_id = '#{admin_group_id}'"

    self.admin = false
    Account.mysql.query(group_sql) do |admin_info|
      admin_info.each_hash do |admin_info_row|
        self.admin = true
      end
    end

    self.save

    return self
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
