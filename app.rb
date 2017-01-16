require "sinatra"
require "sinatra/reloader" if development?
require_relative "./model/caesar_cipher.rb"
require_relative "./model/mastermind/Players.rb"
require_relative "./model/mastermind/Board.rb"
require_relative "./model/mastermind/Game.rb"

enable :sessions

get "/" do
	"This is Chris' Sinatra Portfolio"
end

get "/caesar-cipher" do
	if params[:string] && params[:shift]
		string = params[:string]
		shift = params[:shift].to_i
		cipher = CaesarCipher.caesar_cipher(string, shift)
		cleartext = ""
	elsif params[:cipher]
		cipher_text = params[:cipher]
		cleartext = CaesarCipher.crack_caesar_cipher(cipher_text)
		cipher = ""
	else
		cipher = ""
		cleartext = ""
	end
	erb :index, :locals => {:cipher => cipher, :cleartext => cleartext}
end

get "/mastermind" do
	erb :mastermind
end

post "/mastermind/game" do
	session[:name] = params[:name]
	session[:setter] = params[:setter]
	setter = session[:setter]
	session[:guesses] = 12
	session[:feedback] = ""
	if setter == "guess" 
		session[:colors] = AI.set_master_code 
		session[:guess_feedback_history] = []
	else 
		session[:board_set] = "false"
	end
	redirect("/mastermind/game")
end

get "/mastermind/game" do
	name = session[:name]
	setter = session[:setter]
	@feedback = session[:feedback]
	@colors = session[:colors]
	@board_set = session[:board_set]
	@guesses = session[:guesses].to_i
	if setter == "guess"
		@guess_feedback_history = session[:guess_feedback_history]
	elsif setter == "set" && @board_set == "true"
		AI.remember_feedback(@feedback) unless @feedback.empty?
		@guess = AI.guess(@guesses)
		session[:guesses] = @guesses - 1
	end
	erb :mastermind_game, :locals => {:name => name, :setter => setter}
end

post "/mastermind/set" do
	@colors = []
	params.each {|p, v| @colors << v}
	session[:colors] = @colors
	session[:board_set] = "true"
	redirect("/mastermind/game")
end

post "/mastermind/feedback" do
	setter = session[:setter]
	guesses = session[:guesses].to_i
	if setter == "set"
		feedback = [params[:color1_feedback], params[:color2_feedback], params[:color3_feedback], params[:color4_feedback]]
	else
		guess = [params[:color1_guess], params[:color2_guess], params[:color3_guess], params[:color4_guess]]
		session[:guesses] = guesses - 1
		feedback = AI.feedback(guess)
		session[:guess_feedback_history] << [guess, feedback]
	end
	if setter == "set" && feedback == ["X", "X", "X", "X"]
		redirect("/mastermind/lose")
	elsif setter == "set" && guesses == 0
		redirect("/mastermind/win")
	elsif setter == "guess" && feedback == ["X", "X", "X", "X"]
		redirect("/mastermind/win")
	elsif setter == "guess" && guesses == 0
		redirect("/mastermind/lose")
	else
		session[:feedback] = feedback
		redirect("/mastermind/game")
	end
end

get "/mastermind/win" do
	name = session[:name]
	erb :mastermind_win, :locals => {:name => name}
end

get "/mastermind/lose" do
	name = session[:name]
	erb :mastermind_lose, :locals => {:name => name}
end