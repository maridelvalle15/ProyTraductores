#
# Proyecto Traductores
# 
# Integrantes:
# 	Andres Navarro      11-10688
# 	Marisela Del Valle  11-10217
#
# Fecha Ultima Modificacion: 
# 	29/04/2015

# Clase que crea un token para el simbolo valido para Lanscii encontrado en el archivo

class Token

	# Inicializa los atributos de la clase
	def initialize(type,value,nline,ncolumn)
		@type = type 		# Tipo del simbolo
		@value = value 		# Valor del simbolo
		@nline = nline 		# Linea del archivo en donde se encuentra el simbolo
		@ncolumn = ncolumn 	# Columna del archivo en donde se encuentra el simbolo
	end

	# Devuelve el tipo del simbolo
	def get_type
		return @type
	end

	# Devuelve el valor del simbolo
	def get_value
		return @value
	end

	# Devuelve el numero de la linea del archivo en donde se encuentra el simbolo
	def get_nline
		return @nline
	end

	# Devuelve el numero de la columna del archivo en donde se encuentra el simbolo
	def get_ncolumn
		return @ncolumn
	end
end