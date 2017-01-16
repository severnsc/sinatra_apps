class AI

	@@colors = ["red", "blue", "green", "yellow", "white", "orange"]
	@@feedback = ""
	@@guess = []
	@@master = []
	@@master_hash = Hash.new(0)

	def self.set_master_code
		@@master = []
		4.times {@@master.push(@@colors[rand(6)])}
		@@master.each {|color| @@master_hash[color] += 1}
		@@master
	end

	def self.feedback(guess)
		correct = Hash.new(0)
		feedback = ["", "", "", ""]
		guess.each_with_index do |g ,index|
			if g == @@master[index]
				feedback[index] = "X"
				correct[g] += 1
			end
		end
		guess.each_with_index do |g, index|
			if feedback[index] != "X"
				correct[g] < @@master_hash[g] ? feedback[index] = "O" : feedback[index] = "W"
			end
		end
		feedback
	end

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