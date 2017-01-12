require "sinatra"
require "sinatra/reloader"

class CaesarCipher

	def self.caesar_cipher(string, shift)
		alphabet = ('a'..'z').to_a
		letters = string.split("")
    	letters.collect! do |letter|
			if /[A-Za-z]/.match(letter) != nil
				index = alphabet.index(letter.downcase)
				if /[A-Z]/.match(letter) != nil
					letter = alphabet[index-shift].upcase
				else
					letter = alphabet[index-shift]
				end
        	else
          		letters
			end
		end
        word = letters.join
		word
	end

end

get "/" do
	erb :index
end