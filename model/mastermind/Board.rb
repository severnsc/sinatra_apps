class Board
	
	def initialize(params = {})
		colors = ["red", "green", "blue", "orange", "white", "yellow"]
		if params.fetch(:master) == "computer"
			@master_row = []
			4.times {@master_row.push(colors[rand(6)])}
			@master_colors = Hash.new(0)
			@master_row.each {|color| @master_colors[color] += 1}
		else
			puts "What do you want the master code to be? You can choose any four from: Red, Green, Blue, Orange, White or Yellow. Colors can repeat as often as you like.\n Enter colors with a comma space."
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
		puts "Computer guessed: \n #{guess} \n Give the computer feedback by typing X for every color that is in the correct position, O for colors in the wrong position but included in the master code and Wrong for colors that aren't in the code. Separate with comma space."
		@human_feedback = gets.chomp.upcase.split(", ")
		while @human_feedback != @feedback
			puts "The feedback you provided wasn't correct. I would know. I'm the board. Try again."
			@human_feedback = gets.chomp.upcase.split(", ")
		end
		@number_correct = @correct.values.inject(0) {|sum, i| sum + i}
		[@number_correct, @feedback]
	end
end