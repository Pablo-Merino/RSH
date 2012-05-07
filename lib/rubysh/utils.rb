module Screen
	def self.clear
		#print "\e[2J\e[f" # old method, doesn't works on Linux
    	system('clear') # more UNIX compliant, yet less Ruby native
	end
end