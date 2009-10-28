class Log < ActiveRecord::Base
  belongs_to :account
  belongs_to :character
  belongs_to :raid
  belongs_to :loot

  named_scope :by, lambda { |account| {
      :conditions => { :account_id => account } } }

  named_scope :for, lambda { |character| {
      :conditions => { :character_id => character } } }

  named_scope :in, lambda { |raid| {
      :conditions => { :raid_id => raid } } }

  named_scope :loot, lambda { |loot| {
      :conditions => { :loot_id => loot } } }

  named_scope :from, lambda { |type| {
      :conditions => { :source => type } } }

  default_scope :order => 'created_at'
end
