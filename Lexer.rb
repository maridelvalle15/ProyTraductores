#
# Proyecto Traductores
# 
# Integrantes:
# 	Andres Navarro      11-10688
# 	Marisela Del Valle  11-10217
#
# Fecha Ultima Modificacion: 
# 	03/05/2015

require "./Token.rb"
require "./InvalidWord.rb"

# Clase que inicializa los arreglos de tokens y/o caracteres inesperados (en caso de ser encontrados), contiene procesimientos relacionados a los tokens y convierte los simbolos, segun corresponda el caso, en tokens

class Lexer

	# Inicializa los arreglos de tokens y/o caracteres invalidos
	def initialize
		@tokens = Array.new
		@invalids = Array.new
		@comment = Array.new
		@copy = Array.new
	end

	# Devuelve el arreglo de tokens
	def get_tokens
		return @tokens
	end

	# Devuelve el arreglo de caracteres invalidos
	def get_invalids
		return @invalids
	end

	def get_comment
		return @comment
	end

	# Imprime los atributos de cada elemento del arreglo de tokens
	def print_tokens
		@tokens.each do |token|
			print "token #{token.get_type} value (#{token.get_value}) "
			puts "at line: #{token.get_nline}, column: #{token.get_ncolumn}" 
		end
	end

	# Imprime los atributos de cada elemento del arreglo de caracteres invalidos
	def print_invalids
		@invalids.each do |invalids|
			print "Error: Unexpected character: \"#{invalids.get_value}\" "
			puts "at line: #{invalids.get_nline}, column: #{invalids.get_ncolumn}"  
		end
	end
	# Imprime que no se cerre el comentario en lanscii
	def print_comment
		@comment.each do |comment|
			print "Error: Comment section opened but not closed"
			puts "at line: #{comment.get_nline}, column: #{comment.get_ncolumn}"  
		end
	end
	# Metodo para ser utilizado por racc (Parser)
	def next_token
		if (token = @tokens.shift) != nil
			@copy << token
			return token.get_token
		else
			return nil
		end
	end
	
	# Lectura del archivo. Se lee linea por linea, y a medida que se encuentran se toman la(s) palabra(s) o caracter(es) para identificar si pertenecen o no al lenguaje
	def read(file)
		nline = 0			# entero que cuenta el numero de lineas en el archivo
		comment = false 	# booleano que indica si se ha encontrado o no un comentario
		file.each_line do |line|
			nline +=1		# Para cada linea se imcrementa el contador en 1
			ncolumn = 1		# En cada nueva linea se inicializa el contador de columnas del 					archivo en 1 

			# Se chequea que la linea a leer no sea vacia
			while line != ""				
				# Para cada linea, se evaluan distintas expresiones regulares para la creacion del token
				case line

				# Caso inicio/fin de comentario ( {-,-} )
				when /^(\{\-|\-\})/
					word = line[/^(\{\-|\-\})/]
					if word == "\{\-"
						comment = true 		# se encontro el inicio de comentario
						@comment << Token.new(nil,nil,nline,ncolumn)
					elsif word == "\-\}"
						comment = false 	# se cerro el comentario
						@comment.pop
					end
					# Para este caso no se crea token, simplemente se corta la linea para continuar con la evaluacion de los siguientes caracteres/pabras
					line = line.partition(word).last
					# Para saber en que columna se encuentra la siguiente palabra/caracter, en lugar de incrementarlo en 1 se le incrementa en el tamaño de la palabra que se haya encontrado
					ncolumn += word.size()

				# Caso true,false,read,write
				when /^(true|false|read|write)/
					word = line[/^(true|false|read|write)/]
					line = line.partition(word).last
					# Verifica que la palabra no este dentro de un comentario
					if !comment then
						# Si se cumple la condicion, se crea un nuevo token
						if word == "true" 
							@tokens << Token.new(:TRUE,word,nline,ncolumn)
						elsif word == "false" 
							@tokens << Token.new(:FALSE,word,nline,ncolumn)
						elsif word == "read"
							@tokens << Token.new(:READ,word,nline,ncolumn)
						elsif word == "write"
							@tokens << Token.new(:WRITE,word,nline,ncolumn)
					 	end
					 end
					 # Para saber en que columna se encuentra la siguiente palabra/caracter, en lugar de incrementarlo en 1 se le incrementa en el tamaño de la palabra que se haya encontrado
					 ncolumn += word.size()
					 
				# Caso cualquier palabra que no sea true,false,read,write (identificadores)
				when /^[a-zA-Z_][a-zA-Z0-9_]*/
					word = line[/^[a-zA-Z_][a-zA-Z0-9_]*/]
					line = line.partition(word).last
					# Verifica que el identificador no este dentro de un comentario
					if !comment then
						# Si se cumple la condicion, se crea un nuevo token
						@tokens << Token.new(:IDENTIFIER,word,nline,ncolumn)
					end
					# Para saber en que columna se encuentra la siguiente palabra/caracter, en lugar de incrementarlo en 1 se le incrementa en el tamaño de la palabra que se haya encontrado
					ncolumn += word.size()

				# Caso para los numeros
				when /^[0-9][0-9]*/
					word = line[/^[0-9][0-9]*/]
					line = line.partition(word).last
					# Verifica que el numero no este dentro de un comentario
					if !comment then
						# Si se cumple la condicion, se crea un nuevo token
							@tokens << Token.new(:NUMBER,word.to_i,nline,ncolumn)
					end
					# Para saber en que columna se encuentra la siguiente palabra/caracter, en lugar de incrementarlo en 1 se le incrementa en el tamaño de la palabra que se haya encontrado
					ncolumn += word.size()

				# Caso operadores booleanos (/\,\/,^)
				when /^(\\\/|\/\\|\^)/
					word = line[/^(\\\/|\/\\|\^)/]
					line = line.partition(word).last
					# Verifica que el operador no este dentro de un comentario
					if !comment then
						# Si se cumple la condicion, se crea un nuevo token
						if word == "\^" 
							 @tokens << Token.new(:NOT,word,nline,ncolumn)
						elsif word == "\\\/" 
							@tokens << Token.new(:OR,word,nline,ncolumn)
						elsif word == "\/\\" 
							@tokens << Token.new(:AND,word,nline,ncolumn)
						end
					end
					# Para saber en que columna se encuentra la siguiente palabra/caracter, en lugar de incrementarlo en 1 se le incrementa en el tamaño de la palabra que se haya encontrado
					ncolumn += word.size()
					
				# Caso lienzos (<|>,<\>,<->,< >,#)
				when /^(<(\||\\|\/|\-|\_|\s)>|#)/
					word = line[/^(<(\||\\|\/|\-|\_|\s)>|#)/]
					line = line.partition(word).last
					# Verifica que el lienzo no este dentro de un comentario
					if !comment then
						# Si se cumple la condicion, se crea un nuevo token
						if word == "#" then 
							@tokens << Token.new(:EMPTY_CANVAS,word,nline,ncolumn)
						else
							@tokens << Token.new(:CANVAS,word[1],nline,ncolumn)
						end
					end
					# Para saber en que columna se encuentra la siguiente palabra/caracter, en lugar de incrementarlo en 1 se le incrementa en el tamaño de la palabra que se haya encontrado
					ncolumn += word.size()

				# Caso <=,>=,/=,>,<,=
				when /^(>=|<=|\/=|>|<|=)/
					word = line[/^(>=|<=|\/=|>|<|=)/]
					line = line.partition(word).last
					# Verifica que el operador no este dentro de un comentario
					if !comment then
						# Si se cumple la condicion, se crea un nuevo token
						if word == ">="
							@tokens << Token.new(:MORE_EQUAL,word,nline,ncolumn)
						elsif word == "<="
							@tokens << Token.new(:LESS_EQUAL,word,nline,ncolumn)
						elsif word == "\/="
							@tokens << Token.new(:INEQUAL,word,nline,ncolumn)
						elsif word == ">"
							@tokens << Token.new(:MORE,word,nline,ncolumn)
						elsif word == "<"
							@tokens << Token.new(:LESS,word,nline,ncolumn)
						elsif word == "="
							@tokens << Token.new(:EQUAL,word,nline,ncolumn)
						end
					end
					# Para saber en que columna se encuentra la siguiente palabra/caracter, en lugar de incrementarlo en 1 se le incrementa en el tamaño de la palabra que se haya encontrado
					ncolumn += word.size()

				# Caso !,%,@
				when /^[!%@]/
					word = line[/^[!%@]/]
					line = line.partition(word).last
					# Verifica que el caracter no este dentro de un comentario
					if !comment then
						# Si se cumple la condicion, se crea un nuevo token
						if word == "!"
							@tokens << Token.new(:EXCLAMATION_MARK,word,nline,ncolumn)
						elsif word == "%"
							@tokens << Token.new(:PERCENT,word,nline,ncolumn)
						elsif word == "@"
							@tokens << Token.new(:AT,word,nline,ncolumn)
						end
					end
					# Para saber en que columna se encuentra la siguiente palabra/caracter, en lugar de incrementarlo en 1 se le incrementa en el tamaño de la palabra que se haya encontrado
					ncolumn += word.size()

				# Caso operadores aritmeticos (+,-,*,/)
				when /^(\+|-|\*|\/)/
					word = line[/^(\+|-|\*|\/)/]
					line = line.partition(word).last
					# Verifica que el caracter no este dentro de un comentario
					if !comment then
						# Si se cumple la condicion, se crea un nuevo token
						if word == "\+"
							@tokens << Token.new(:PLUS,word,nline,ncolumn)
						elsif word == "-"
							@tokens << Token.new(:MINUS,word,nline,ncolumn)
						elsif word == "\*"
							@tokens << Token.new(:MULTIPLY,word,nline,ncolumn)
						elsif word == "\/"
							@tokens << Token.new(:DIVISION,word,nline,ncolumn)
						
						end
					end
					# Para saber en que columna se encuentra la siguiente palabra/caracter, en lugar de incrementarlo en 1 se le incrementa en el tamaño de la palabra que se haya encontrado
					ncolumn += word.size()

				# Caso :,|,$,',&,~,;
				when /^[:|$'&~]/
					word = line[/^[:|$'&~]/]
					line = line.partition(word).last
					# Verifica que el caracter no este dentro de un comentario
					if !comment then
						# Si se cumple la condicion, se crea un nuevo token
						if word == ":"
							@tokens << Token.new(:COLON,word,nline,ncolumn)
						elsif word == "|"
							@tokens << Token.new(:PIPE,word,nline,ncolumn)
						elsif word == "$"
							@tokens << Token.new(:DOLLAR,word,nline,ncolumn)
						elsif word == "'"
							@tokens << Token.new(:APOSTROPHE,word,nline,ncolumn)
						elsif word == "&"
							@tokens << Token.new(:AMPERSAND,word,nline,ncolumn)
						elsif word == "~"
							@tokens << Token.new(:VIRGUILE,word,nline,ncolumn)
						end
					end
					# Para saber en que columna se encuentra la siguiente palabra/caracter, en lugar de incrementarlo en 1 se le incrementa en el tamaño de la palabra que se haya encontrado
					ncolumn += word.size()

				# Caso {,},[,],(,),?,;,..
				when /^(\{|\}|\[|\]|\(|\)|\?|;|\.\.)/
					word = line[/^(\{|\}|\[|\]|\(|\)|\?|;|\.\.)/]
					line = line.partition(word).last
					# Verifica que el caracter no este dentro de un comentario
					if !comment then
						# Si se cumple la condicion, se crea un nuevo token
						if word == "{"
							@tokens << Token.new(:LCURLY,word,nline,ncolumn)
						elsif word == "}"
							@tokens << Token.new(:RCURLY,word,nline,ncolumn)
						elsif word == "["
							@tokens << Token.new(:LBRACKET,word,nline,ncolumn)
						elsif word == "]"
							@tokens << Token.new(:RBRACKET,word,nline,ncolumn)
						elsif word == "("
							@tokens << Token.new(:LPARENTHESIS,word,nline,ncolumn)
						elsif word == ")"
							@tokens << Token.new(:RPARENTHESIS,word,nline,ncolumn)
						elsif word == "?"
							@tokens << Token.new(:INTERROGATION_MARK,word,nline,ncolumn)
						elsif word == ";"
							@tokens << Token.new(:SEMI_COLON,word,nline,ncolumn)
						elsif word == "\.\."
							@tokens << Token.new(:DOUBLE_DOT,word,nline,ncolumn)
						end
					end
					# Para saber en que columna se encuentra la siguiente palabra/caracter, en lugar de incrementarlo en 1 se le incrementa en el tamaño de la palabra que se haya encontrado
					ncolumn += word.size()

				# Caso espacio en blanco
				when /^\s/
					line = line.partition(/^\s/).last
					# El tamaño de la columna se incrementa en 1, porque este es el tamaño correspondiente a 1 espacio
					ncolumn += 1

				# Caso simbolo no aceptado por el lenguaje
				else
					word = line[/^[^\s\w]/]
					line = line.partition(word).last
					# Verifica que no este dentro de un comentario
					if !comment then
						# Si se cumple la condicion, se crea un nuevo token
						@invalids << InvalidWord.new(word,nline,ncolumn)
					end
					# Para saber en que columna se encuentra la siguiente palabra/caracter, en lugar de incrementarlo en 1 se le incrementa en el tamaño de la palabra que se haya encontrado
					ncolumn += word.size()

				# Cierra case
				end
			# Cierra while
			end
		# Cierra do
		end	
	# Cierra procedimiento read
	end
# Cierra la clase
end