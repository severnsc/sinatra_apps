class AI

	def initialize
		@colors = ["red", "blue", "green", "yellow", "white", "orange"]
	end

	def guess(guesses)
		if guesses == 12
			@guess = ["red", "blue", "green", "yellow"]
		else
			@feedback.each_with_index do |f, index|
				if f == "WRONG"
					@colors.delete(@guess[index])
				end
			end
			@feedback.each_with_index do |f, index|
				if f == "WRONG"
					@guess[index] = @colors[rand(@colors.count)]
				end
			end
			colors_to_swap = []
			@feedback.each_with_index do |f, index|
				if f != "X"
					colors_to_swap.push(@guess[index])
				end
			end
			@feedback.each_with_index do |f, index|
				if f != "X"
					@guess[index] = colors_to_swap[-1]
					colors_to_swap.pop
				end
			end
		end
		@guess
	end

	def remember_feedback(feedback)
		@feedback = feedback
	end

end