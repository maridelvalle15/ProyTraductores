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
	def initializa(type,value,nline,ncolum)
		@type = type
		@value = value
		@nline = nline
		@ncolum = ncolum
	end
end

class Lexer
	def initialize
		@tokens = Array.new
		@invalids = Array.new
	end

	def read(file)
		nline = 0
		file.each_line do |line|
			#words = line.split
			nline +=1
			ncolumn = 1
			while line != ""
				#puts "Entra aqui3"
				case line
					#puts "Entra aqui"
				when /^\{\-/
					#puts "Entra aqui3"
					word = line[/^\{\-/]
					line = line.partition(word).last
					puts "#{ncolumn} #{word}"
					ncolumn += word.size()
					 
				when /^[a-zA-Z][a-zA-Z0-9_]*/
					#puts "Entra aqui2"
					word = line[/^[a-zA-Z][a-zA-Z0-9_]*/]
					line = line.partition(word).last
					puts "#{ncolumn} #{word}"
					ncolumn += word.size()
					
				when /^\-\}/
					#puts "Entra aqui1"
					word = line[/^\-\}/]
					line = line.partition(word).last
					puts "#{ncolumn} #{word}"
					ncolumn += word.size()

				when /^<(\||\\|\/|\-|\_|\s)>/
					#puts "Entra aqui1"
					word = line[/^<(\||\\|\/|\-|\_|\s)>/]

					line = line.partition(word).last
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

lexer = Lexer.new
lexer.read(file)