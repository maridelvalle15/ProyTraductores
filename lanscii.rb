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


class Lexer
	def initialize
		@tokens = Array.new
		@invalids = Array.new
	end

	def read(file)
		file.each_line do |line|
			puts "#{line}"
		end
	end
end

name_file = ARGV[0]
file = open(name_file,"r")

lexer = Lexer.new
lexer.read(file)