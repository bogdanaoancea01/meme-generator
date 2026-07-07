class User < ActiveRecord:: Base
    validates :username, presence: true, uniqueness: true
    validates :password, presence: true
    validates :token, uniqueness: true, allow_nil: true
end