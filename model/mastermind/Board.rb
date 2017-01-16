class Board

	attr_reader :master_row
	
	def initialize(params = {})
		colors = ["red", "green", "blue", "orange", "white", "yellow"]
		if params.fetch(:master) == "computer"
			@master_row = []
			4.times {@master_row.push(colors[rand(6)])}
			@master_colors = Hash.new(0)
			@master_row.each {|color| @master_colors[color] += 1}
		else
			@master_row = gets.chomp.downcase.split(", ")
			until @master_row.all? {|color| colors.include?(color)}
				puts "One or more of your colors isn't valid! Choose only valid colors: #{colors}"
				@master_row = gets.chomp.downcase.split(", ")
			end
			@master_colors = Hash.new(0)
			@master_row.each {|color| @master_colors[color] += 1}
		end
	end

	def computer_feedback(guess)
		@correct = Hash.new(0)
		@feedback = ["","","",""]
		guess.each_with_index do |g, index|
			if g == @master_row[index]
				@feedback[index] = "X"
				@correct[g] += 1
			end
		end
		guess.each_with_index do |g, index|
			if @feedback[index] != "X"
				@correct[g] < @master_colors[g] ? @feedback[index] = "O" : @feedback[index] = "Wrong"
			end
		end
		puts "\n"
		@feedback.each {|f| puts f}
		@correct.values.inject(0) {|sum, i| sum + i}
	end

	def human_feedback(guess)
		@correct = Hash.new(0)
		@feedback = ["", "", "", ""]
		guess.each_with_index do |g, index|
			if g == @master_row[index]
				@feedback[index] = "X"
				@correct[g] += 1
			end
		end
		guess.each_with_index do |g, index|
			if @feedback[index] != "X"
				@correct[g] < @master_colors[g] ? @feedback[index] = "O" : @feedback[index] = "WRONG"
			end
		end
		#If human feedback doesn't equal feedback
		@number_correct = @correct.values.inject(0) {|sum, i| sum + i}
		[@number_correct, @feedback]
	end
end