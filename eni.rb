#!/usr/bin/ruby
# HTML / URL Encoder/Decoder

require 'cgi'
require 'open-uri'

decode_times = ''

def html_encode(val)
	string = CGI.escapeHTML(val)
	return string
end

def html_decode(val)
	string = CGI.unescapeHTML(val)
	return string
end

def url_encode(val)
  	string = CGI.escape(val)
  	return string	
end

def url_decode(val)
	string = CGI.unescape(val)
	return string
end


# safely handle the third arguement, which is optional for multiple encoding
begin 
	decode_times = ARGV[2]
rescue 
end

begin
	
	decoder_type = ARGV[0]
	decoder_value = ARGV[1]
	
	case decoder_type

	when '--htmle'
		
		if decode_times
			new_value = decoder_value
			decode_times = decode_times.to_i
			(1..decode_times).each do |count|
				new_value = html_encode(new_value)
				if count >= decode_times
					puts new_value
					system("echo '"+new_value+"' | pbcopy")
				end
			end
		else
			puts html_encode(decoder_value)
			system("echo '"+html_encode(decoder_value)+"' | pbcopy")

		end
	
	when '--htmld'
		puts html_decode(decoder_value)
		system("echo '"+html_decode(decoder_value)+"' | pbcopy")

	when '--urle'
		if decode_times
			decode_times = decode_times.to_i
			new_value = decoder_value
			
			(1..decode_times).each do |count|
				new_value = url_encode(new_value)
				if count >= decode_times
					puts new_value
					system("echo "+new_value+" | pbcopy")
				end

			end
		
		else
			puts url_encode(decoder_value)
			system("echo "+url_encode(decoder_value)+" | pbcopy")	
		end
		
		

	when '--urld'
		puts url_decode(decoder_value)
		system("echo "+url_decode(decoder_value)+" | pbcopy")

	else
		puts "Incorrect syntax, try again or run with --help flag"
		puts "
		,--.                     
		|        o               
		|-   ;-. . ,-: ;-.-. ,-: 
		|    | | | | | | | | | | 
		`--' ' ' ' `-| ' ' ' `-` 
		           `-'         "
		puts "A command line character encoder/decoder -- results are directly copied to the clipboard"
		puts "\n###### Current Commands ######\n\n"
		puts "Ex: $ ./eni.rb --htmle \'value\' -- HTML Encode"
		puts "Ex: $ ./eni.rb --htmld \'value\' -- HTML Decode"
		puts "Ex: $ ./eni.rb --urle \'value\' -- URL Decode"
		puts "Ex: $ ./eni.rb --urld \'value\' -- URL Decode\n\n"
	end
	
rescue 
	
	puts "\nError, missing argument."
	puts "Ex: $ ./eni.rb --htmle \'(\'"
	puts "Remember, special characters must be escaped via the \\ character\n\n"
	
end

