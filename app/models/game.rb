class Game < ActiveRecord::Base
	belongs_to :match
	
	def safe_id
		return self.id
	end
	
end
