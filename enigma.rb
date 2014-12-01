#!/usr/bin/ruby
# A command line character encoder/decoder -- results are directly copied to the clipboard

require 'rbconfig'
require 'cgi'
require 'digest'
require 'base64'
require 'optparse'

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

	  def blue
	  	colorize(34)
	  end
	end
	puts "
,--.                     
|        o               
|-   ;-. . ,-: ;-.-. ,-: 
|    | | | | | | | | | |  
`--' ' ' ' `-| ' ' ' `-`  v1.1
           `-'         ".green
else
	puts "
,--.                     
|        o               
|-   ;-. . ,-: ;-.-. ,-: 
|    | | | | | | | | | |  
`--' ' ' ' `-| ' ' ' `-`  v1.1
           `-'         "
end

puts "A command line character encoder/decoder\n"
puts "Usage: ./enigma.rb  OR  ./enigma.rb 'value' \n\n"

$go_again_bool = ''
$value = ARGV[0]
$count = 0
$choice
interactive = true

def print_results(val)
	puts val
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
		puts "\nResult: "+val.yellow+" (#{result_len} characters long)"
	else
		puts "\nResult: "+val+" (#{result_len} characters long)"
	end
end


def interactive_mode()
	def alter_value(choice)
		case choice

		when "1"
			$value = CGI.escape($value)
			$value = $value.gsub(/\+/, "%20") # Make sure url encoded spaces are %20 instead of +
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
			$value = $value.unpack('B*').join("")
		when "10"
			$value = $value.scan(/.{1,8}/).collect{|x| x.to_i(2).chr}.join("")
		when "11"
			$value = Digest::MD5.hexdigest($value)
		when "12"
			$value = Digest::SHA1.hexdigest($value)
		when "13"
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
		puts "How would you like to alter: #{$value} (1-11)"
		if !$win
			print "\n\t\t\#\# Encodings \#\#".green
		else
			print "\n\t\t\#\# Encodings \#\#"
		end
		puts "\n1. URL Encode \t\t\t 6. URL Decode"
		puts "2. HTML Encode (basic) \t\t 7. HTML Decode"
		puts "3. HTML Encode (decimal) \t ---"
		puts "4. HTML Encode (hexadecimal) \t ---"
		puts "5. Base64 Encode \t\t 8. Base64 Decode"
		if !$win
			print "\n\t\t\#\# Conversions \#\#".green
		else
			print "\n\t\t\#\# Conversions \#\#"
		end
		puts ""
		puts "9. ASCII to Binary \t\t 10. Binary to ASCII"
		if !$win
			print "\n\t\t\#\# Hashing \#\#".green
		else
			print "\n\t\t\#\# Hashing \#\#"
		end
		puts ""
		puts "11. MD5 Hash\n"
		puts "12. SHA1 Hash\n"
		puts "13. SHA256 Hash\n"

		$choice = $stdin.gets.chomp
		alter_value($choice)
	
		interactive_decoder_value = $stdin.gets.chomp
end

options = {}

OptionParser.new do |opts|
  opts.on("--urle VALUE", "--ue", "URL Encode") do |value|
    value = CGI.escape(value)
	value = value.gsub(/\+/, "%20") # Make sure url encoded spaces are %20 instead of +
    print_current(value)
    print_results(value)
    interactive = false
  end
end.parse!


if interactive
	interactive_mode()
end