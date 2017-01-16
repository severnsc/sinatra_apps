require_relative './Players'
require_relative './Board'
require_relative './AI'

class Game
	attr_reader :guesses, :current_guess, :game_over
	attr_accessor :board

	def initialize player
		@player = player
		@guesses = 12
		@correct = 0
		@game_over = false
	end

	def setup_game setter
		@response = setter
		@response == "guess" ? start_game_human_guess : start_game_computer_guess
	end

	def start_game_human_guess
		@board = Board.new({:master => "computer"})
	end

	def start_game_computer_guess
		@board = Board.new({:master => "human"})
		@ai = AI.new
	end

	def play_turn_human_guess
		unless @guesses == 0 || @correct == 4
			@current_guess = @player.guess
			@guesses -= 1
			@correct = @board.computer_feedback(@current_guess)
		else
			human_guess_end_game
		end
	end

	def play_turn_computer_guess(guesses)
		@guesses = guesses
		unless @guesses == 0 || @correct == 4
			@current_guess = AI.guess(@guesses)
			@guesses -= 1
			get_human_feedback
		else
			computer_guess_end_game
		end
	end

	def get_human_feedback
		@human_feedback = @board.human_feedback(@current_guess)
		@correct = @human_feedback[0]
		@ai.remember_feedback(@human_feedback[1])
	end

	def play_again?
		puts "Do you want to play again #{@player.name}? Type Yes or No"
		@answer = gets.chomp.downcase
		setup_game if @answer == "yes"
	end

	def computer_guess_end_game
		@game_over = true
		if @guesses == 0 && @correct != 4
			puts "#{@player.name}, you stumped the computer!! You win!"
			play_again?
		elsif @correct == 4
			puts "Game over #{@player.name}! You lose!"
			play_again?
		end
	end

	def human_guess_end_game
		@game_over = true
		if @guesses == 0 && @correct != 4
			puts "Game over #{@player.name}! You lose!"
			play_again?
		elsif @correct == 4
			puts "You got the code right #{@player.name}! You win!"
			play_again?
		end
	end

end