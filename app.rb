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
	if setter == "guess"
		board = Board.new({:master => "computer"})
		session[:master] = board.master_row
	else
		session[:board_set] = "false"
		session[:feedback] = ""
		session[:guesses] = 12
	end
	redirect("/mastermind/game")
end

get "/mastermind/game" do
	name = session[:name]
	setter = session[:setter]
	feedback = session[:feedback]
	@colors = session[:colors]
	@board_set = session[:board_set]
	guesses = session[:guesses].to_i
	if setter == "guess"
	else
		AI.remember_feedback(feedback) unless feedback.empty?
		@guess = AI.guess(guesses)
		session[:guesses] = guesses - 1
	end
	erb :mastermind_game, :locals => {:name => name, :setter => setter}
end

post "/mastermind/set" do
	colors = [params[:color1], params[:color2], params[:color3], params[:color4]]
	session[:colors] = @colors
	session[:board_set] = "true"
	redirect("/mastermind/game")
end

post "/mastermind/feedback" do
	feedback = params[:human_feedback]
	setter = session[:setter]
	guesses = session[:guesses].to_i
	if setter == "set" && feedback == "X, X, X, X"
		redirect("/mastermind/lose")
	elsif setter == "set" && guesses == 0
		redirect("/mastermind/win")
	elsif setter == "guess" && feedback == "X, X, X, X"
		redirect("/mastermind/win")
	elsif setter == "guess" && guesses == 0
		redirect("/mastermind/lose")
	else
		session[:feedback] = feedback
		redirect("/mastermind/game")
	end
end