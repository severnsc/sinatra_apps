require './Players'
require './Board'
require './AI'

class Game
	attr_accessor :game, :board

	def initialize player
		@player = player
		setup_game
	end

	def setup_game
		puts "#{@player.name}, do you want to guess or set the master code?\n Type Guess or Set"
		@response = gets.chomp.downcase
		until @response == "guess" || @response == "set"
			puts "Invalid response! Please type Guess or set"
			@response = gets.chomp.downcase
		end
		@response == "guess" ? play_game_human_guess : play_game_computer_guess
		return "Bye #{@player.name}!"
	end

	def play_game_human_guess
		@board = Board.new({:master => "computer"})
		@guesses = 12
		@correct = 0
		play_turn_human_guess until @guesses == 0 || @correct == 4
		if @guesses == 0 && @correct != 4
			puts "Game over #{@player.name}! You lose!"
			play_again?
		elsif @correct == 4
			puts "You got the code right #{@player.name}! You win!"
			play_again?
		end
	end

	def play_game_computer_guess
		@board = Board.new({:master => "human"})
		@ai = AI.new
		@guesses = 12
		@correct = 0
		play_turn_computer_guess until @guesses == 0 || @correct == 4
		if @guesses == 0 && @correct != 4
			puts "#{@player.name}, you stumped the computer!! You win!"
			play_again?
		elsif @correct == 4
			puts "Game over #{@player.name}! You lose!"
			play_again?
		end
	end

	def play_turn_human_guess
		puts "\n #{@player.name}, make your guess of the Master Code. Separate colors with comma space. Colors: Red, Blue, Green, Yellow, White, Orange. Guesses left: #{@guesses}"
		@current_guess = @player.guess
		@guesses -= 1
		@correct = @board.computer_feedback(@current_guess)
		puts "\n[X - Correct color in the correct spot; O - the color is in the Master code]"
	end

	def play_turn_computer_guess
		@current_guess = @ai.guess(@guesses)
		@guesses -= 1
		@human_feedback = @board.human_feedback(@current_guess)
		@correct = @human_feedback[0]
		@ai.remember_feedback(@human_feedback[1])
	end

	def play_again?
		puts "Do you want to play again #{@player.name}? Type Yes or No"
		@answer = gets.chomp.downcase
		setup_game if @answer == "yes"
	end

end
Game.new