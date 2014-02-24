#!/usr/bin/ruby
# A command line character encoder/decoder -- results are directly copied to the clipboard

require 'rbconfig'
require 'cgi'
require 'digest/md5'
require 'base64'

os = Config::CONFIG["arch"]
$clipboard = false

if /darwin/.match(os)
	$clipboard = true
end

puts "
,--.                     
|        o               
|-   ;-. . ,-: ;-.-. ,-: 
|    | | | | | | | | | | 
`--' ' ' ' `-| ' ' ' `-` 
           `-'         "
puts "A command line character encoder/decoder\n"
puts "Usage: ./eni.rb  OR  ./eni.rb 'value' \n\n"

$go_again_bool = ''
$value = ARGV[0]
$count = 0
$choice

def print_results(val)
	result = val.strip
	puts "\nResult (copied to clipboard): "+result

	if $clipboard
		result = result.gsub(/%/, "%%")
		system("printf '"+result+"' | pbcopy")
	end
	exit 1
end


def interactive_mode()
	def alter_value(choice)
		case choice

		when "1"
			$value = CGI.escapeHTML($value)
			puts "\nCurrent Value: "+$value
		when "2"
			$value = CGI.unescapeHTML($value)
			puts "\nCurrent Value: "+$value
		when "3"
			$value = CGI.escape($value)
			puts "\nCurrent Value: "+$value
		when "4"
			$value = CGI.unescape($value)
			puts "\nCurrent Value: "+$value
		when "5"
			$value = Base64.encode64($value)
			puts "\nCurrent Value: "+$value
		when "6"
			$value = Base64.decode64($value)
			puts "\nCurrent Value: "+$value
		when "7"
			$value = Digest::MD5.hexdigest($value)
			puts "\nCurrent Value: "+$value
		end



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
		puts "What value would you like to encode or decode?"
		$value = $stdin.gets.chomp
		$count += 1
	end
		puts "How would you like to alter: "+$value+" (1-7)"
		puts "\n\t 1. HTML Encode"
		puts "\t 2. HTML Decode"
		puts "\t 3. URL Encode"
		puts "\t 4. URL Decode"
		puts "\t 5. Base64 Encode"
		puts "\t 6. Base64 Decode"
		puts "\t 7. MD5 Hash\n"

		$choice = $stdin.gets.chomp
		alter_value($choice)
	
		interactive_decoder_value = $stdin.gets.chomp
		

end

interactive_mode()
