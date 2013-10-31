class User < ActiveRecord::Base
	#downcase emails to reduce changes of email duplication
	before_save { self.email = email.downcase }
	
	#validation for login
	validates :name, presence: true , length: { maximum: 50 }
	
	#validation for email
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	
	#allows bcrypt to do it's magic
	has_secure_password
	
	validates :password, length { minimum: 10 }
end
