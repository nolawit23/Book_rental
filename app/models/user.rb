class User < ApplicationRecord
    has_secure_password
   validates :name, presence: true
    validates :email, presence: true, uniqueness: { case_sensitive: false }
    validates :password, presence: true, length: { minimum: 8 }, if: :password_present?
    has_secure_password

    private
    def password_present?
        !password.nil?
end 
end 
