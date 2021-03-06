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
          		letter
			end
		end
        word = letters.join
		word
	end

	def self.crack_caesar_cipher cipher
		alphabet = ("a".."z").to_a
		i = 1
		possibles = []
		while i<26
			letters = cipher.downcase.split("")
			letters.collect! do |letter|
				if /[A-Za-z]/.match(letter) != nil
					index = alphabet.index(letter)
					letter = alphabet[index-i]
				else
				letter
				end
			end
			possibles << letters.join
			i+=1
		end
		possibles
	end

end