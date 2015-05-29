#
# Proyecto Traductores
# 
# Integrantes:
# 	Andres Navarro      11-10688
# 	Marisela Del Valle  11-10217
#
# Fecha Ultima Modificacion: 
# 	3/05/2015

# Archivo main del proyecto

require "./Lexer.rb"
require "./Parser.rb"


name_file = ARGV[0]				# Nombre del archivo recibido por entrada
file = open(name_file,"r")		
token = Lexer.new				# Creamos una nueva clase Lexer. Se inicializan los arreglos de tokens y de caracteres invalidos
token.read(file)				# Se inicia la lectura del archivo de entrada

# Se imprimen los caracteres invalidos si fueron encontrados en el archivo
if token.get_comment.size > 0
	token.print_comment
elsif token.get_invalids.size > 0 
	token.print_invalids
# Se imprimen los tokens si no se encontraron errores en el archivo
else 
	token.print_tokens
end

parser = Parser.new(token);
parser.parser