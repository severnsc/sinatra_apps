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
	redirect("/mastermind/game")
end

get "/mastermind/game" do
	name = session[:name]
	setter = session[:setter]
	unless @game
		@board_set? = false
		@player = Player.new name
		@game = Game.new @player
		@game.setup_game(setter)
	else
		
	end
	erb :mastermind_game, :locals => {:name => name, :setter => setter}
end