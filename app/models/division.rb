class Division < ActiveRecord::Base

	def level
		return division_level.split.last
	end

end
