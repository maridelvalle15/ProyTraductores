#
# Proyecto Traductores
# 
# Integrantes:
# 	Andres Navarro      11-10688
# 	Marisela Del Valle  11-10217
#
# Fecha Ultima Modificacion: 
# 	29/04/1993

require "./Lexer.rb"

name_file = ARGV[0]
file = open(name_file,"r")

token = Lexer.new
token.read(file)
token.print
