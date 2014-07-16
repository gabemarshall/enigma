#!/usr/bin/ruby
# A command line character encoder/decoder -- results are directly copied to the clipboard

require 'rbconfig'
require 'cgi'
require 'digest'
require 'base64'

begin
	require 'htmlentities'
rescue LoadError
  puts "Hmm...htmlentities gem was not found."
  puts "If this is your first time, be sure to run bundle install or gem install htmlentities."
  exit
end


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

if !$win
	class String
	  
	  def colorize(color_code)
	    "\e[#{color_code}m#{self}\e[0m"
	  end

	  def red
	    colorize(31)
	  end

	  def green
	    colorize(32)
	  end

	  def yellow
	    colorize(33)
	  end
	end
	puts "
,--.                     
|        o               
|-   ;-. . ,-: ;-.-. ,-: 
|    | | | | | | | | | |  
`--' ' ' ' `-| ' ' ' `-`  v1.0
           `-'         ".green
else
	puts "
,--.                     
|        o               
|-   ;-. . ,-: ;-.-. ,-: 
|    | | | | | | | | | |  
`--' ' ' ' `-| ' ' ' `-`  v1.0
           `-'         "
end

puts "A command line character encoder/decoder\n"
puts "Usage: ./eni.rb  OR  ./eni.rb 'value' \n\n"

$go_again_bool = ''
$value = ARGV[0]
$count = 0
$choice

def print_results(val)
	result = val.strip

	if $mac
		puts "\nResult is copied to clipboard...Cheers!\n"
		result = result.gsub(/%/, "%%")
		system("printf '"+result+"' | pbcopy")
	elsif $win
		puts "\nResult copied to clipboard...Cheers!\n"
		system("echo "+result+" | clip")
	else 
		puts "\nResult copied to clipboard...Cheers!\n"
		result = result.gsub(/%/, "%%")
		system("printf '"+result+"' | xclip -selection clipboard")
	end
	exit 1
end

def print_current(val)
	result_len = val.length
	result_len = result_len.to_s
	if !$win
		puts "\nResult: "+$value.yellow+" (#{result_len} characters long)"
	else
		puts "\nResult: "+$value+" (#{result_len} characters long)"
	end
end


def interactive_mode()
	def alter_value(choice)
		case choice

		when "1"
			$value = CGI.escape($value)
		when "2"
			coder = HTMLEntities.new
			$value = CGI.escapeHTML($value)
		when "3"
			coder = HTMLEntities.new
			$value = coder.encode($value, :decimal)
		when "4"
			coder = HTMLEntities.new
			$value = coder.encode($value, :hexadecimal)
		when "5"
			$value = Base64.encode64($value)
		when "6"
			$value = CGI.unescape($value)
		when "7"
			$value = CGI.unescapeHTML($value)
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
		puts "How would you like to alter: "+$value+" (1-11)"
		puts "\n\t 1. URL Encode"
		puts "\t 2. HTML Encode (basic)"
		puts "\t 3. HTML Encode (decimal)"
		puts "\t 4. HTML Encode (hexadecimal)"
		puts "\t 5. Base64 Encode"
		puts ""
		puts "\t 6. URL Decode"
		puts "\t 7. HTML Decode"
		puts "\t 8. Base64 Decode"
		puts "" 
		puts "\t 9. MD5 Hash\n"
		puts "\t 10. SHA1 Hash\n"
		puts "\t 11. SHA256 Hash\n"

		$choice = $stdin.gets.chomp
		alter_value($choice)
	
		interactive_decoder_value = $stdin.gets.chomp
		

end

interactive_mode()
