require "sinatra"
require "sinatra/reloader" if development?
require_relative "./model/caesar_cipher.rb"
require_relaive "./model/mastermind"

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
	@session = session
	erb :mastermind
end

post "/mastermind" do
	name = params[:name]
	@player = Player.new name
	@game = Game.new @player
	@session["name"] = name
	redirect to("/mastermind/game")
end

get "/mastermind/game" do
	erb :mastermind_game
end