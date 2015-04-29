#
# Proyecto Traductores
# 
# Integrantes:
#
# Andres Navarro      11-10688
# Marisela Del Valle  11-10217
#
# Fecha Ultima Modificacion
# 29/04/1993

=begin
class Tokens

end
=end

class Token
	def initialize(type,value,nline,ncolumn)
		@type = type
		@value = value
		@nline = nline
		@ncolumn = ncolumn
	end

	def get_type
		return @type
	end

	def get_value
		return @value
	end

	def get_nline
		return @nline
	end

	def get_ncolumn
		return @ncolumn
	end
end

class Lexer
	def initialize
		@tokens = Array.new
		@invalids = Array.new
	end

	def print
		@tokens.each do |token|
			puts "token #{token.get_type} value (#{token.get_value}) at line: #{token.get_nline}, column: #{token.get_ncolumn}" 
		end
	end
	def read(file)
		nline = 0
		comment = false
		file.each_line do |line|
			#words = line.split
			nline +=1
			ncolumn = 1

			while line != ""
				#puts "Entra aqui3"
				case line
					#puts "Entra aqui"
				when /^\{\-/
					comment = true
					word = line[/^\{\-/]
					line = line.partition(word).last
					puts "#{ncolumn} #{word}"
					ncolumn += word.size()

				when /^\-\}/
					comment = false
					word = line[/^\-\}/]
					line = line.partition(word).last
					puts "#{ncolumn} #{word}"
					ncolumn += word.size()
					 
				when /^[a-zA-Z][a-zA-Z0-9_]*/
					#puts "Entra aqui2"
					word = line[/^[a-zA-Z][a-zA-Z0-9_]*/]
					line = line.partition(word).last
					if !comment then
						@tokens << Token.new("INDENTIFIER",word,nline,ncolumn)
					end
					puts "#{ncolumn} #{word}"
					ncolumn += word.size()
					
				when /^<(\||\\|\/|\-|\_|\s)>/
					#puts "Entra aqui1"
					word = line[/^<(\||\\|\/|\-|\_|\s)>/]
					line = line.partition(word).last
					if !comment then
						@tokens << Token.new("CANVAS",word[1],nline,ncolumn)
					end
					puts "#{ncolumn} #{word[1]}"
					ncolumn += word.size()
					
				when /^\s/
					line = line.partition(/^\s/).last
					ncolumn += 1
				end
			end
			puts "#{nline}"
		end
	end
end

name_file = ARGV[0]
file = open(name_file,"r")


token = Lexer.new
token.read(file)
token.print
