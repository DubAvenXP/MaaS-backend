class Assignment < ApplicationRecord
	belongs_to :user
	belongs_to :shift


	def assign(something)
		puts "*********************************"
		puts something
		puts "*********************************"
	end

end
