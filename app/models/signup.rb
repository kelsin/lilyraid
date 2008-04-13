class Signup < ActiveRecord::Base
    belongs_to :raid
    belongs_to :character

    has_many :signup_roles, :dependent => :destroy
    has_many :roles, :through => :signup_roles

    has_one :slot, :dependent => :nullify

    def date
        created_at
    end

    def other_signups
        raid.signups_from(character.account) - [self]
    end

    def has_other_signups
        other_signups.size > 0
    end

    def role_ids=(roles)
        @roles = roles
    end

    def after_create
        @roles.each do |role|
            SignupRole.new(:signup => self, :role => Role.find(role)).save
        end

        reload
    end
end
