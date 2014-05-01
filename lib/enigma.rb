require "enigma/version"

module Enigma
	class Eni
		require 'rbconfig'
		require 'cgi'
		require 'digest'
		require 'base64'
		require 'htmlentities'


		os = RbConfig::CONFIG["arch"]

		$mac = false
		$win = false
		$linux = false

		if /darwin/.match(os)
			$mac = true
		elsif /mingw32/.match(os)
			$win = true
		else
			$linux = true
		end

		### If not using windows, colorize output by extending String class ###
		#######################################################################


		puts "
		,--.                     
		|        o               
		|-   ;-. . ,-: ;-.-. ,-: 
		|    | | | | | | | | | |  
		`--' ' ' ' `-| ' ' ' `-`  v1.0
		           `-'         "
		

		puts "A command line character encoder/decoder\n"
		puts "Usage: ./eni.rb  OR  ./eni.rb 'value' \n\n"

		$go_again_bool = ''
		$value = ARGV[0]
		$count = 0
		$choice

		def print_results(val)
			result = val.strip

			if $mac
				puts "\nResult copied to clipboard...Cheers! 🍻 \n"
				result = result.gsub(/%/, "%%")
				system("printf '"+result+"' | pbcopy")
			elsif $win
				puts "\nResult copied to clipboard...Cheers!\n"
				system("echo "+result+" | clip")
			else 
				puts "Cheers!"
			end
			exit 1
		end

		def print_current(val)
			if !$win
				puts "\nResult: "+$value
			else
				puts "\nResult: "+$value
			end
		end


		def interactive_mode()
			def alter_value(choice)
				case choice

				when "1"
					$value = CGI.escapeHTML($value)
				when "2"
					coder = HTMLEntities.new
					$value = coder.encode($value, :decimal)
				when "3"
					coder = HTMLEntities.new
					$value = coder.encode($value, :hexadecimal)
				when "4"
					$value = CGI.unescapeHTML($value)
				when "5"
					$value = CGI.escape($value)
				when "6"
					$value = CGI.unescape($value)
				when "7"
					$value = Base64.encode64($value)
				when "8"
					$value = Base64.decode64($value)
				when "9"
					$value = Digest::MD5.hexdigest($value)
				when "10"
					$value = Digest::SHA1.hexdigest($value)
				when "11"
					$value = Digest::SHA256.hexdigest($value)
				end

			print_current($value)

			puts "\nWould you like to encode/decode this value again? (Y/n)"
			$go_again_bool = $stdin.gets.chomp
			$go_again_bool = $go_again_bool.upcase

			if $go_again_bool == 'Y'
				interactive_mode()
			else
				print_results($value)
			end
			
			end

			if $count == 0 && !$value
				puts "What value would you like to alter?"
				$value = $stdin.gets.chomp
				$count += 1
			end
				puts "How would you like to alter: "+$value+" (1-9)"
				puts "\n\t 1. HTML Encode (basic)"
				puts "\t 2. HTML Encode (decimal)"
				puts "\t 3. HTML Encode (hexadecimal)"
				puts "\t 4. HTML Decode"
				puts "\t 5. URL Encode"
				puts "\t 6. URL Decode"
				puts "\t 7. Base64 Encode"
				puts "\t 8. Base64 Decode"
				puts "\t 9. MD5 Hash\n"
				puts "\t 10. SHA1 Hash\n"
				puts "\t 11. SHA256 Hash\n"

				$choice = $stdin.gets.chomp
				alter_value($choice)
			
				interactive_decoder_value = $stdin.gets.chomp
				

		end

		
	end
end