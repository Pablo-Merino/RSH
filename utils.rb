module Screen
	def self.clear
		print "\e[2J\e[f"
	end
end