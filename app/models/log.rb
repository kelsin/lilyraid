class Log < ActiveRecord::Base
  belongs_to :account
  belongs_to :character
  belongs_to :raid
  belongs_to :loot

  scope :by, lambda { |account| {
      :conditions => { :account_id => account } } }

  scope :for, lambda { |character| {
      :conditions => { :character_id => character } } }

  scope :in, lambda { |raid| {
      :conditions => { :raid_id => raid } } }

  scope :loot, lambda { |loot| {
      :conditions => { :loot_id => loot } } }

  scope :from, lambda { |type| {
      :conditions => { :source => type } } }

  default_scope :order => 'created_at desc'
end
