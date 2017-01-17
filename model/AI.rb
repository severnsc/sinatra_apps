class AI
	class << self; attr_reader :colors end

	@colors = ["red", "blue", "green", "yellow", "white", "orange"]
	@@feedback = ""

	def self.set_master_code
		colors = ["red", "blue", "green", "yellow", "white", "orange"]
		master = []
		master_hash = Hash.new(0)
		4.times {master.push(colors[rand(6)])}
		master.each {|color| master_hash[color] += 1}
		master
	end

	def self.feedback(guess, master)
		correct = Hash.new(0)
		master_hash = Hash.new(0)
		master.each {|color| master_hash[color] += 1}
		feedback = ["", "", "", ""]
		guess.each_with_index do |g ,index|
			if g == master[index]
				feedback[index] = "X"
				correct[g] += 1
			end
		end
		guess.each_with_index do |g, index|
			if feedback[index] != "X"
				correct[g] < master_hash[g] ? feedback[index] = "O" : feedback[index] = "W"
			end
		end
		feedback
	end

	def self.guess(guesses, feedback, guess)
		if guesses == 12
			@colors = ["red", "blue", "green", "yellow", "white", "orange"]
			guess = ["red", "blue", "green", "yellow"]
		else
			feedback.each_with_index do |f, index|
				if f == "W"
					@colors.delete(guess[index])
				end
			end
			feedback.each_with_index do |f, index|
				if f == "W"
					guess[index] = @colors[rand(@colors.count)]
				end
			end
			colors_to_swap = []
			feedback.each_with_index do |f, index|
				if f != "X"
					colors_to_swap.push(guess[index])
				end
			end
			feedback.each_with_index do |f, index|
				if f != "X"
					guess[index] = colors_to_swap[rand(colors_to_swap.count)]
					colors_to_swap.pop
				end
			end
		end
		guess
	end

	def self.remember_feedback(feedback)
		@@feedback = feedback
	end

end