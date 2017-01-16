class AI

	@@colors = ["red", "blue", "green", "yellow", "white", "orange"]
	@@feedback = ""
	@@guess = []

	def self.guess(guesses)
		if guesses == 12
			@@guess = ["red", "blue", "green", "yellow"]
		else
			@@feedback.each_with_index do |f, index|
				if f == "W"
					@@colors.delete(@@guess[index])
				end
			end
			@@feedback.each_with_index do |f, index|
				if f == "W"
					@@guess[index] = @@colors[rand(@@colors.count)]
				end
			end
			colors_to_swap = []
			@@feedback.each_with_index do |f, index|
				if f != "X"
					colors_to_swap.push(@@guess[index])
				end
			end
			@@feedback.each_with_index do |f, index|
				if f != "X"
					@@guess[index] = colors_to_swap[-1]
					colors_to_swap.pop
				end
			end
		end
		@@guess
	end

	def self.remember_feedback(feedback)
		@@feedback = feedback
	end

end