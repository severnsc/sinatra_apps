class Player
	attr_accessor :name

	def initialize name
		@name = name
	end

	def guess
		@guess = gets.chomp.downcase.split(", ")
		while @guess.count != 4
			puts "Invalid input! Please enter four colors separated by comma space like so: Color, color, color, color"
			@guess = gets.chomp.downcase.split(", ")
		end
		@guess
	end

end