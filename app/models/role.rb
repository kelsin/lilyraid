class Role < ActiveRecord::Base
    has_many :cclass_roles, :dependent => :destroy
    has_many :cclasses, :through => :cclass_roles

    has_many :signup_roles, :dependent => :destroy
    has_many :signups, :through => :signup_roles
end
