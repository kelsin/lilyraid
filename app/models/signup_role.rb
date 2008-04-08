class SignupRole < ActiveRecord::Base
    belongs_to :signup
    belongs_to :role
end
