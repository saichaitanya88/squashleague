class User < ActiveRecord::Base
	#downcase emails to reduce changes of email duplication
	before_save { self.email = email.downcase }
	before_create :create_remember_token
	#validation for login
	validates :name, presence: true , length: { maximum: 50 }
	
	#validation for email
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	
	#allows bcrypt to do it's magic
	has_secure_password
	
	validates :password, length: { minimum: 10 }
	
	
	def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
	
	
end
